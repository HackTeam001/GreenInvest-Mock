//green-invest

import type { Meta, StoryObj } from '@storybook/react';
import ConnectWalletWarning from '@/src/components/ui/ConnectWalletWarning';

const meta = {
  component: ConnectWalletWarning,
  tags: ['autodocs'],
  argTypes: {},
} satisfies Meta<typeof ConnectWalletWarning>;

export default meta;
type Story = StoryObj<typeof meta>;

export const Primary: Story = {
  args: {
    action: 'to vote',
  },
};
