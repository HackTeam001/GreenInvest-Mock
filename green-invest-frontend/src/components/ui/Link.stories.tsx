//green-invest

import type { Meta, StoryObj } from '@storybook/react';
import { userEvent, within } from '@storybook/testing-library';

import { Link } from '@/src/components/ui/Link';

const meta = {
  component: Link,
  tags: ['autodocs'],
  argTypes: {
    icon: {
      table: {
        disable: true,
      },
    },
  },
} satisfies Meta<typeof Link>;

export default meta;
type Story = StoryObj<typeof meta>;

export const Default: Story = {
  args: {
    variant: 'default',
    label: 'Link',
    to: '#',
  },
};

export const Outline: Story = {
  args: {
    variant: 'outline',
    label: 'Link',
    to: '#',
  },
};

export const Clicked: Story = {
  ...Default,
  play: async ({ canvasElement }) => {
    const canvas = within(canvasElement);
    userEvent.hover(canvas.getByRole('link'));
    userEvent.click(canvas.getByRole('link'));
  },
};
