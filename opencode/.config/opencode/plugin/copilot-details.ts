import type { Plugin, PluginInput } from "@opencode-ai/plugin";
import {
  getCopilotSubscriptionDetails,
  getCopilotToken,
} from "./copilot-lib/quota";
import type { GithubUserResponse, QuotaSnapshot } from "./copilot-lib/types";

interface ProgressBarOptions {
  width: number;
  filledChar: string;
  emptyChar: string;
}
const defaultProgressBarOptions: ProgressBarOptions = {
  width: 20,
  filledChar: "█",
  emptyChar: "░",
};
function getProgressBar(
  premiumDetails: QuotaSnapshot,
  options?: Partial<ProgressBarOptions>,
) {
  const opts = { ...defaultProgressBarOptions, ...options };

  const filledCount = Math.round(
    (1 - premiumDetails.percent_remaining / 100) * opts.width,
  );
  const emptyCount = opts.width - filledCount;
  return `${opts.filledChar.repeat(filledCount)}${opts.emptyChar.repeat(emptyCount)}`;
}

type ShowToastFunction = PluginInput["client"]["tui"]["showToast"];
type ShowToastArgs = Parameters<ShowToastFunction>[0];

function toastCopilotDetails(
  subscriptionDetails: GithubUserResponse | null,
): ShowToastArgs {
  if (!subscriptionDetails) {
    return {
      body: {
        variant: "warning",
        title: "Copilot Plugin",
        message: "Failed to extract Copilot subscription details.",
        duration: 3000,
      },
    };
  }

  const premiumDetails =
    subscriptionDetails.quota_snapshots.premium_interactions;
  const progressBar = getProgressBar(premiumDetails);
  const percentageUsed = (100 - premiumDetails.percent_remaining).toFixed(1);

  const remainderStr = `${premiumDetails.quota_remaining.toFixed(1)}/${premiumDetails.entitlement.toFixed(1)} left`;

  const components = [`${progressBar} ${percentageUsed}%`, remainderStr];
  const variant = premiumDetails.percent_remaining < 25 ? "warning" : "info";
  return {
    body: {
      variant,
      title: "Copilot Premium Requests",
      message: components.join("\n"),
      duration: 8000,
    },
  };
}

export const copilotPlugin: Plugin = async (ctx) => {
  const token = getCopilotToken();
  if (!token) {
    return {};
  }
  const subscriptionDetails = await getCopilotSubscriptionDetails(token);
  if (!subscriptionDetails) {
    return {};
  }

  return {
    event: async function ({ event }) {
      if (event.type !== "session.idle") return;
      const toastArgs = toastCopilotDetails(subscriptionDetails);
      ctx.client.tui.showToast(toastArgs);
    },
  };
};
