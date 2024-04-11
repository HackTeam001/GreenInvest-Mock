//green-invest

import { withReactHookForm } from '@/src/lib/decorators/reactHookFormDecorator';
import type { Meta, StoryObj } from '@storybook/react';

import { WithdrawAssetsInput } from './WithdrawAssetsInput';

const meta: Meta<typeof WithdrawAssetsInput> = {
  component: WithdrawAssetsInput,
};

export default meta;

type Story = StoryObj<typeof WithdrawAssetsInput>;

export const Primary: Story = {
  args: {
    register: (() => {}) as any,
    prefix: 'actions.1.',
    errors: {},
    onRemove: (() => {}) as any,
  },
  decorators: [withReactHookForm],
};
