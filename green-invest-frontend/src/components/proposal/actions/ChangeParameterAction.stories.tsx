//green-invest

import type { Meta, StoryObj } from '@storybook/react';
import { Accordion } from '../../ui/Accordion';

import { ChangeParameterAction } from './ChangeParameterAction';

const meta: Meta<typeof ChangeParameterAction> = {
  component: ChangeParameterAction,
};

export default meta;
type Story = StoryObj<typeof ChangeParameterAction>;

export const Primary: Story = {
  args: {
    value: 'first',
    action: {
      method: 'changeParam',
      interface: 'IChangeParam',
      params: {
        plugin: 'A plugin',
        parameter: 'parameter 1',
        value: '3.14159',
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
