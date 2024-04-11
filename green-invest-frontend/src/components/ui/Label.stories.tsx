//green-invest

import type { Meta, StoryObj } from '@storybook/react';
import { Input } from '@/src/components/ui/Input';
import React from 'react';

import { Label } from '@/src/components/ui/Label';

const meta: Meta<typeof Label> = {
  tags: ['autodocs'],
  component: Label,
  argTypes: {
    htmlFor: {
      table: {
        disable: true,
      },
    },
    asChild: {
      table: {
        disable: true,
      },
    },
  },
};

export default meta;
type Story = StoryObj<typeof Label>;

export const Primary: Story = {
  args: {
    htmlFor: 'test',
    children: 'This is a label for the below input',
  },
  decorators: [
    (Story) => (
      <div>
        <Story />
        <Input id="test" />
      </div>
    ),
  ],
};

export const WithTooltip: Story = {
  args: {
    htmlFor: 'test',
    children: 'This is a label for the below input',
    tooltip: 'This is a tooltip',
  },
  decorators: [
    (Story) => (
      <div>
        <Story />
        <Input id="test" />
      </div>
    ),
  ],
};
