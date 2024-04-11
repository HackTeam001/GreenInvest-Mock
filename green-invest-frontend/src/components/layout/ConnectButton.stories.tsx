//green-invest

import ConnectButton from '@/src/components/layout/ConnectButton';
import type { Meta, StoryObj } from '@storybook/react';

const meta = {
  component: ConnectButton,
  tags: ['autodocs'],
  argTypes: {},
} satisfies Meta<typeof ConnectButton>;

export default meta;
type Story = StoryObj<typeof meta>;

export const Default: Story = {
  args: {},
};
