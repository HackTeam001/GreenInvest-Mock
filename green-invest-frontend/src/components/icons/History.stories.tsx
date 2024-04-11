//green-invest

import type { Meta, StoryObj } from '@storybook/react';
import History from '@/src/components/icons/History';

const meta = {
  component: History,
  tags: ['autodocs'],
  argTypes: {},
} satisfies Meta<typeof History>;

export default meta;
type Story = StoryObj<typeof meta>;

export const Default: Story = {
  args: {
    className: 'w-5 h-5',
  },
};
