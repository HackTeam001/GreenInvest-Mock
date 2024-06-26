//green-invest

import VotesContent from '@/src/components/proposal/VotesContent';
import { dummyProposal } from '@/src/hooks/useProposal';
import { ProposalStatus } from '@aragon/sdk-client';
import type { Meta, StoryObj } from '@storybook/react';

const meta = {
  component: VotesContent,
  tags: ['autodocs'],
  argTypes: {
    proposal: {
      table: {
        disable: true,
      },
    },
  },
} satisfies Meta<typeof VotesContent>;

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
  },
};

export const Pending: Story = {
  args: {
    proposal: {
      ...dummyProposal,
      status: ProposalStatus.PENDING,
    },
  },
};

export const Succeeded: Story = {
  args: {
    proposal: {
      ...dummyProposal,
      status: ProposalStatus.SUCCEEDED,
    },
  },
};

export const Executed: Story = {
  args: {
    proposal: {
      ...dummyProposal,
      status: ProposalStatus.EXECUTED,
    },
  },
};

export const Defeated: Story = {
  args: {
    proposal: {
      ...dummyProposal,
      status: ProposalStatus.DEFEATED,
    },
  },
};
