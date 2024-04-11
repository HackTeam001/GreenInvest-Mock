//green-invest

import type { Meta, StoryObj } from '@storybook/react';
import ProposalMilestone from '@/src/components/proposal/ProposalMilestone';

const meta = {
  component: ProposalMilestone,
  tags: ['autodocs'],
  argTypes: {},
} satisfies Meta<typeof ProposalMilestone>;

export default meta;
type Story = StoryObj<typeof meta>;

const decorator = (Story: any) => (
  <div className="w-96">
    <Story />
  </div>
);

export const Done: Story = {
  args: {
    label: 'Published',
    blockNumber: 8283818,
    variant: 'done',
    date: new Date(),
  },
  decorators: [decorator],
};

export const NoBlockNumber: Story = {
  args: {
    label: 'Published',
    variant: 'done',
    date: new Date(),
  },
  decorators: [decorator],
};

export const NoDate: Story = {
  args: {
    label: 'Published',
    variant: 'done',
  },
  decorators: [decorator],
};

export const Loading: Story = {
  args: {
    label: 'Running',
    variant: 'loading',
    date: new Date(),
  },
  decorators: [decorator],
};

export const Failed: Story = {
  args: {
    label: 'Defeated',
    variant: 'failed',
    date: new Date(),
  },
  decorators: [decorator],
};

export const Executed: Story = {
  args: {
    label: 'Executed',
    variant: 'executed',
    date: new Date(),
  },
  decorators: [decorator],
};
