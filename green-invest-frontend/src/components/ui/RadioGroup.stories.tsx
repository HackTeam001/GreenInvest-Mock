//green-invest

import type { Meta, StoryObj } from '@storybook/react';

import { RadioGroup, RadioGroupItem } from '@/src/components/ui/RadioGroup';

const meta: Meta<typeof RadioGroup> = {
  tags: ['autodocs'],
  component: RadioGroup,
  argTypes: {
    children: {
      table: {
        disable: true,
      },
    },
  },
};

export default meta;
type Story = StoryObj<typeof RadioGroup>;

export const Primary: Story = {
  args: {
    defaultValue: '2',
    children: (
      <>
        <RadioGroupItem value="1" />
        <RadioGroupItem value="2" />
        <RadioGroupItem value="3" />
      </>
    ),
  },
};
