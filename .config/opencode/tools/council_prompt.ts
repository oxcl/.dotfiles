import { tool } from "@opencode-ai/plugin"
import { readFileSync, writeFileSync } from "fs"
import { join } from "path"

export const write = tool({
  description: "Writes a council prompt to a temp file and returns a reference ID",
  args: {
    prompt: tool.schema.string().describe("The full prompt text to store"),
  },
  async execute(args) {
    const id = crypto.randomUUID()
    const filePath = join("/tmp", `council-prompt-${id}.txt`)
    writeFileSync(filePath, args.prompt, "utf-8")
    return id
  },
})

export const read = tool({
  description: "Reads a council prompt by its reference ID",
  args: {
    id: tool.schema.string().describe("The reference ID returned by council_prompt_write"),
  },
  async execute(args) {
    const filePath = join("/tmp", `council-prompt-${args.id}.txt`)
    return readFileSync(filePath, "utf-8")
  },
})
