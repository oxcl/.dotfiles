import { tool } from "@opencode-ai/plugin"
import { readFileSync, writeFileSync } from "fs"
import { join } from "path"

export const write = tool({
  description: "Writes a handoff to a temp file and returns a reference ID. Use when you need to pass context to another agent.",
  args: {
    prompt: tool.schema.string().describe("The full handoff content to store"),
  },
  async execute(args) {
    const id = crypto.randomUUID()
    const filePath = join("/tmp", `handoff-${id}.txt`)
    writeFileSync(filePath, args.prompt, "utf-8")
    return id
  },
})

export const read = tool({
  description: "Reads a handoff by its reference ID. Use to retrieve context passed from another agent.",
  args: {
    id: tool.schema.string().describe("The reference ID returned by handoff_write"),
  },
  async execute(args) {
    const filePath = join("/tmp", `handoff-${args.id}.txt`)
    return readFileSync(filePath, "utf-8")
  },
})
