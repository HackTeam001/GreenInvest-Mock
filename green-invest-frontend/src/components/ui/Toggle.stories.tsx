//green-invest

import type { Meta, StoryObj } from '@storybook/react';

import { Toggle } from '@/src/components/ui/Toggle';

const meta: Meta<typeof Toggle> = {
  component: Toggle,
  tags: ['autodocs'],
};

export default meta;
type Story = StoryObj<typeof Toggle>;

export const Default: Story = {
  args: {
    children: 'Toggle me!',
    onClick: () => console.log('Toggled!'),
  },
};

export const Outline: Story = {
  args: {
    ...Default.args,
    variant: 'outline',
  },
};

export const Small: Story = {
  args: {
    ...Default.args,
    size: 'sm',
  },
};

export const SmallOutline: Story = {
  args: {
    ...Default.args,
    variant: 'outline',
    size: 'sm',
  },
};

export const Large: Story = {
  args: {
    ...Default.args,
    size: 'lg',
  },
};

export const LargeOutline: Story = {
  args: {
    ...Default.args,
    variant: 'outline',
    size: 'lg',
  },
};

export const Disabled: Story = {
  args: {
    ...Default.args,
    disabled: true,
  },
};

export const DisabledOutline: Story = {
  args: {
    ...Default.args,
    variant: 'outline',
    disabled: true,
  },
};
