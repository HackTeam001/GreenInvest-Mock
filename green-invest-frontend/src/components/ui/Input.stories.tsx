//green-invest

import type { Meta, StoryObj } from '@storybook/react';

import { Input } from '@/src/components/ui/Input';
import { ErrorWrapper } from '@/src/components/ui/ErrorWrapper';

const meta: Meta<typeof Input> = {
  tags: ['autodocs'],
  component: Input,
};

export default meta;
type Story = StoryObj<typeof Input>;

export const Primary: Story = {
  args: {
    placeholder: 'Placeholder text',
  },
  decorators: [
    (Story) => (
      <div className="w-[400px]">
        <ErrorWrapper name={'textarea'} error={undefined}>
          <Story />
        </ErrorWrapper>
      </div>
    ),
  ],
};

export const Error: Story = {
  args: {
    placeholder: 'Placeholder text',
    error: {
      type: 'required',
    },
  },
  decorators: [
    (Story) => (
      <div className="w-[400px]">
        <ErrorWrapper
          name={'textarea'}
          error={{
            type: 'required',
          }}
        >
          <Story />
        </ErrorWrapper>
      </div>
    ),
  ],
};
