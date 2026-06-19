import type { Plugin } from "@opencode-ai/plugin"
import { tool } from "@opencode-ai/plugin"
import Exa from "exa-js"

const MAX_SEARCH_RESULTS = 5
const MAX_FETCH_CHARS = 5000
const HINT_THRESHOLD = 3
const HINT_WINDOW_MS = 10_000
const HINT_MESSAGE =
  "STOP! It appears that you are running multiple web tool calls. if this is a multi-step or complex research consider using the research subagent instead. otherwise continue."

const plugin: Plugin = async () => {
  const exa = new Exa()
  const callTimestamps = new Map<string, number[]>()

  function shouldAddHint(sessionID: string): boolean {
    const now = Date.now()
    const cutoff = now - HINT_WINDOW_MS
    let timestamps = callTimestamps.get(sessionID)
    if (!timestamps) {
      timestamps = []
      callTimestamps.set(sessionID, timestamps)
    }
    timestamps.push(now)
    while (timestamps.length > 0 && timestamps[0] < cutoff) {
      timestamps.shift()
    }
    return timestamps.length >= HINT_THRESHOLD
  }

  return {
    tool: {
      web_search: tool({
        description:
          `Searches the web. Use for current info, documentation lookups, or any task needing up-to-date information from the web.`,
        args: {
          query: tool.schema.string().describe("The search query"),
        },
        async execute(args, context) {
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

          return shouldAddHint(context.sessionID) && context.agent !== "research"
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
        async execute(args, context) {
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

          return shouldAddHint(context.sessionID) && context.agent !== "research"
            ? fetchResult + "\n\n" + HINT_MESSAGE
            : fetchResult
        },
      }),
    },
  }
}

export default plugin
