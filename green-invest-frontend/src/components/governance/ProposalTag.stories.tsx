//green-invest

import type { Meta, StoryObj } from '@storybook/react';
import { addDays } from 'date-fns';
import ProposalTag from '@/src/components/governance/ProposalTag';
import { countdownText } from '@/src/lib/utils';

const meta = {
  component: ProposalTag,
  tags: ['autodocs'],
  argTypes: {},
} satisfies Meta<typeof ProposalTag>;

export default meta;
type Story = StoryObj<typeof meta>;

export const Countdown: Story = {
  args: {
    variant: 'countdown',
    children: 'Ends in ' + countdownText(addDays(new Date(), 2)),
  },
};

export const YesVotes: Story = {
  args: {
    variant: 'yes',
    children: '16.66%',
  },
};

export const NoVotes: Story = {
  args: {
    variant: 'no',
    children: '0%',
  },
};

export const MintActionTag: Story = {
  args: {
    variant: 'action',
    children: 'Mint tokens',
    icon: 'mint',
  },
};

export const WithdrawActionTag: Story = {
  args: {
    variant: 'action',
    children: 'Withdraw assets',
    icon: 'withdraw',
  },
};

export const MergeActionTag: Story = {
  args: {
    variant: 'action',
    children: 'Merge PR',
    icon: 'merge',
  },
};

export const ChangeParamsActionTag: Story = {
  args: {
    variant: 'action',
    children: 'Change params',
    icon: 'change',
  },
};
