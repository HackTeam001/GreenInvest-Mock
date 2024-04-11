//green-invest

import type { Meta, StoryObj } from '@storybook/react';
import CheckList from '@/src/components/icons/CheckList';

const meta = {
  component: CheckList,
  tags: ['autodocs'],
  argTypes: {},
} satisfies Meta<typeof CheckList>;

export default meta;
type Story = StoryObj<typeof meta>;

export const Default: Story = {
  args: {
    className: 'w-5 h-5',
  },
};
