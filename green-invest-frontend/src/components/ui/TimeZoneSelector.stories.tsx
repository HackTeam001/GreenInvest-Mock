//green-invest

import { withReactHookForm } from '@/src/lib/decorators/reactHookFormDecorator';
import type { Meta, StoryObj } from '@storybook/react';

import { TimezoneSelector } from './TimeZoneSelector';

const meta: Meta<typeof TimezoneSelector> = {
  component: TimezoneSelector,
};

export default meta;
type Story = StoryObj<typeof TimezoneSelector>;

export const Primary: Story = {
  args: {
    error: undefined,
    name: 'test',
    id: '123',
  },
  decorators: [withReactHookForm],
};
