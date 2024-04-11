//green-invest

import DefaultAction from '@/src/components/proposal/actions/DefaultAction';
import { Accordion } from '@/src/components/ui/Accordion';
import type { Meta, StoryObj } from '@storybook/react';

const meta = {
  component: DefaultAction,
  tags: ['autodocs'],
  argTypes: {},
} satisfies Meta<typeof DefaultAction>;

export default meta;
type Story = StoryObj<typeof meta>;

// Required for BigInts to be serialized correctly
// Taken from: https://stackoverflow.com/questions/65152373/typescript-serialize-bigint-in-json
// @ts-ignore
BigInt.prototype.toJSON = function () {
  return this.toString();
};

export const Default: Story = {
  args: {
    value: 'first',
    action: {
      method: 'something_unsupported',
      interface: 'something_unsupported',
      params: {
        test: '123',
      },
    },
  },
  decorators: [
    (Story) => (
      <Accordion type="single" collapsible>
        <Story />
      </Accordion>
    ),
  ],
};
