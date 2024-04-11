//green-invest

import type { Meta, StoryObj } from '@storybook/react';

import { Progress } from '@/src/components/ui/Progress';

const meta: Meta<typeof Progress> = {
  component: Progress,
  tags: ['autodocs'],
  argTypes: {
    asChild: {
      table: {
        disable: true,
      },
    },
  },
};

export default meta;
type Story = StoryObj<typeof Progress>;

export const Primary: Story = {
  args: {
    value: 33,
  },
};

export const ZeroProggress: Story = {
  args: {
    value: 0,
  },
};

export const Done: Story = {
  args: {
    value: 100,
  },
};

export const AlmostDone: Story = {
  args: {
    value: 99,
  },
};

export const Small: Story = {
  args: {
    value: 33,
    size: 'sm',
  },
};
