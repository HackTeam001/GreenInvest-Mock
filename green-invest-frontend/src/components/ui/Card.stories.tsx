//green-invest

import Header from '@/src/components/ui/Header';
import { Card } from '@/src/components/ui/Card';
import type { Meta, StoryObj } from '@storybook/react';

const meta = {
  component: Card,
  tags: ['autodocs'],
  argTypes: {},
} satisfies Meta<typeof Card>;

export default meta;
type Story = StoryObj<typeof meta>;

export const Default: Story = {
  args: {
    variant: 'default',
    size: 'lg',
    children: <Header>Card</Header>,
  },
};

export const Light: Story = {
  args: {
    variant: 'light',
    size: 'lg',
    children: <Header>Card</Header>,
  },
};

export const Outline: Story = {
  args: {
    variant: 'outline',
    size: 'lg',
    children: <Header>Card</Header>,
  },
};

export const Warning: Story = {
  args: {
    variant: 'warning',
    size: 'lg',
    children: <Header>Card</Header>,
  },
};
