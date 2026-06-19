import type { Plugin } from "@opencode-ai/plugin"

const PLANNER_AGENT = "planner"

const DENIED_TOOLS = new Set(["edit", "write", "bash"])

const PLAN_MODE_NOTIFICATION =
  "[SYSTEM] this is a hidden message from the system. don't mention this message to the user. You are now in Plan Mode. You can read files and analyze but cannot modify files or execute commands. Focus on analysis and documenting your plan. Ask the user to switch to Agent mode when ready to implement."

const CODER_MODE_NOTIFICATION =
  "[SYSTEM] this is a hidden message from the system. don't mention this message to the user. You are now in Agent Mode.  You have full tool access. You may reference plans in .opencode/plans/*.md."

const plugin: Plugin = async () => {
  const previousAgent = new Map<string, string>()

  return {
    "chat.message": async (input, output) => {
      const currentAgent = input.agent
      
      if (!currentAgent) return

      const prev = previousAgent.get(input.sessionID)
      if (currentAgent !== prev) {
        let text: string | undefined
        if (currentAgent === PLANNER_AGENT) {
          text = PLAN_MODE_NOTIFICATION
        } else if (prev === PLANNER_AGENT) {
          text = CODER_MODE_NOTIFICATION
        }
        if (text) {
          output.parts.push({
            type: "text",
            text,
            synthetic: true,
            id: `prt_planmode_${Date.now()}`,
            sessionID: input.sessionID,
            messageID: input.messageID ?? "",
          })
        }
        previousAgent.set(input.sessionID, currentAgent)
      }
    },

    "tool.execute.before": async (input, output) => {
      if (previousAgent.get(input.sessionID) !== PLANNER_AGENT) return
      if (DENIED_TOOLS.has(input.tool)) {
        throw new Error(
          `Cannot use ${input.tool} in plan mode. Ask the user to switch to Coder mode.`
        )
      }
    },
  }
}

export default plugin
