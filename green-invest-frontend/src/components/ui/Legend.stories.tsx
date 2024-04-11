//green-invest

import type { Meta, StoryObj } from '@storybook/react';

import Legend from '@/src/components/ui/Legend';

const meta: Meta<typeof Legend> = {
  tags: ['autodocs'],
  component: Legend,
  argTypes: {},
};

export default meta;
type Story = StoryObj<typeof Legend>;

export const Primary: Story = {
  args: {
    children: 'This is a legend element',
  },
  decorators: [
    (Story) => (
      <fieldset>
        <Story />
      </fieldset>
    ),
  ],
};
