//green-invest

import Navbar from '@/src/components/layout/Navbar';
import type { Meta, StoryObj } from '@storybook/react';

const meta = {
  component: Navbar,
  tags: ['autodocs'],
  argTypes: {},
} satisfies Meta<typeof Navbar>;

export default meta;
type Story = StoryObj<typeof meta>;

export const Default: Story = {
  args: {},
};
