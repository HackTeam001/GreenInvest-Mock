//green-invest

import { withReactHookForm } from '@/src/lib/decorators/reactHookFormDecorator';
import type { Meta, StoryObj } from '@storybook/react';

import { ChangeParametersInput } from './ChangeParametersInput';

const meta: Meta<typeof ChangeParametersInput> = {
  component: ChangeParametersInput,
};

export default meta;
type Story = StoryObj<typeof ChangeParametersInput>;

export const Primary: Story = {
  args: {
    register: (() => {}) as any,
    errors: undefined,
    onRemove: (() => {}) as any,
    prefix: 'actions.0',
  },
  decorators: [withReactHookForm],
};
