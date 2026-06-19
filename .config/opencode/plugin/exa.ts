import type { Plugin } from "@opencode-ai/plugin"
import { tool } from "@opencode-ai/plugin"
import Exa from "exa-js"

const MAX_SEARCH_RESULTS = 5
const MAX_FETCH_CHARS = 5000
const HINT_THRESHOLD = 3
const HINT_WINDOW_MS = 10_000
const HINT_MESSAGE =
  "Hint: Consider using the research subagent if you are doing complex searches and data gathering"

const plugin: Plugin = async () => {
  const exa = new Exa()
  const callTimestamps: number[] = []

  function shouldAddHint(): boolean {
    const now = Date.now()
    const cutoff = now - HINT_WINDOW_MS
    callTimestamps.push(now)
    while (callTimestamps.length > 0 && callTimestamps[0] < cutoff) {
      callTimestamps.shift()
    }
    return callTimestamps.length >= HINT_THRESHOLD
  }

  return {
    tool: {
      web_search: tool({
        description:
          `Searches the web. Use for current info, documentation lookups, or any task needing up-to-date information from the web.`,
        args: {
          query: tool.schema.string().describe("The search query"),
        },
        async execute(args) {
          const { results } = await exa.search(args.query, {
            type: "auto",
            numResults: MAX_SEARCH_RESULTS,
            contents: { highlights: { maxCharacters: 2000 } },
          })

          if (results.length === 0) {
            return "No results found."
          }

          const searchResult = results
            .map((r, i) => {
              const highlights = r.highlights?.length
                ? "\n" + r.highlights.join("\n")
                : ""
              return `${i + 1}. **${r.title ?? "Untitled"}**\n   ${r.url}${highlights}`
            })
            .join("\n\n")

          return shouldAddHint()
            ? searchResult + "\n\n" + HINT_MESSAGE
            : searchResult
        },
      }),

      web_fetch: tool({
        description:
          "Fetchs a URL return readable markdown. Supports multiple URLs fetched in parallel. Use to read articles, documentation, or any web page content.",
        args: {
          urls: tool.schema
            .array(tool.schema.url())
            .describe("Array of URLs to fetch"),
        },
        async execute(args) {
          const urls = args.urls.slice(0, 5)

          const { results } = await exa.getContents(urls, {
            text: { maxCharacters: MAX_FETCH_CHARS },
          })

          if (results.length === 0) {
            return "No content retrieved."
          }

          const fetchResult = results
            .map((r) => {
              const text = r.text ?? "(no text content)"
              return `## ${r.title ?? r.url}\n\n${text}`
            })
            .join("\n\n---\n\n")

          return shouldAddHint()
            ? fetchResult + "\n\n" + HINT_MESSAGE
            : fetchResult
        },
      }),
    },
  }
}

export default plugin
