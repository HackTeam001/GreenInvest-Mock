//green-invest

import type { Meta, StoryObj } from '@storybook/react';

import { TextareaWYSIWYG } from '@/src/components/ui/TextareaWYSIWYG';

const meta: Meta<typeof TextareaWYSIWYG> = {
  component: TextareaWYSIWYG,
};

export default meta;
type Story = StoryObj<typeof TextareaWYSIWYG>;

export const Primary: Story = {
  args: {
    setError: () => {},
    clearErrors: () => {},
  },
};
