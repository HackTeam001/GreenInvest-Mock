//green-invest

import type { Meta, StoryObj } from '@storybook/react';

import Logo from '@/src/components/Logo';

const meta: Meta<typeof Logo> = {
  component: Logo,
};

export default meta;
type Story = StoryObj<typeof Logo>;

export const Primary: Story = {
  args: {},
};
