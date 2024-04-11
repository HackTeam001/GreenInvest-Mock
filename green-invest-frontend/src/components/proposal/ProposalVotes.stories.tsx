//green-invest

import ProposalVotes from '@/src/components/proposal/ProposalVotes';
import { dummyProposal } from '@/src/hooks/useProposal';
import { ProposalStatus } from '@aragon/sdk-client';
import type { Meta, StoryObj } from '@storybook/react';

const meta = {
  component: ProposalVotes,
  tags: ['autodocs'],
  argTypes: {
    proposal: {
      table: {
        disable: true,
      },
    },
  },
} satisfies Meta<typeof ProposalVotes>;

export default meta;
type Story = StoryObj<typeof meta>;

// Required for BigInts to be serialized correctly
// Taken from: https://stackoverflow.com/questions/65152373/typescript-serialize-bigint-in-json
// @ts-ignore
BigInt.prototype.toJSON = function () {
  return this.toString();
};

export const Active: Story = {
  args: {
    proposal: dummyProposal,
    loading: false,
  },
};

export const Pending: Story = {
  args: {
    proposal: {
      ...dummyProposal,
      status: ProposalStatus.PENDING,
    },
    loading: false,
  },
};

export const Succeeded: Story = {
  args: {
    proposal: {
      ...dummyProposal,
      status: ProposalStatus.SUCCEEDED,
    },
    loading: false,
  },
};

export const Executed: Story = {
  args: {
    proposal: {
      ...dummyProposal,
      status: ProposalStatus.EXECUTED,
    },
    loading: false,
  },
};

export const Defeated: Story = {
  args: {
    proposal: {
      ...dummyProposal,
      status: ProposalStatus.DEFEATED,
    },
    loading: false,
  },
};

export const Loading: Story = {
  args: {
    proposal: dummyProposal,
    loading: true,
  },
};
