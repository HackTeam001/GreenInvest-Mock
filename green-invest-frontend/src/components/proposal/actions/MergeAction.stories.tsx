//green-invest

import { Accordion } from '@/src/components/ui/Accordion';
import type { Meta, StoryObj } from '@storybook/react';
import MergeAction from './MergeAction';

const meta = {
  component: MergeAction,
  tags: ['autodocs'],
  argTypes: {},
} satisfies Meta<typeof MergeAction>;

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
      method: 'merge',
      interface: 'IMerge',
      params: {
        url: 'https://github.com/SecureSECODAO/dao-webapp/pull/43',
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
