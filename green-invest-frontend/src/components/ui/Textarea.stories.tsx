//green-invest

import type { Meta, StoryObj } from '@storybook/react';

import { ErrorWrapper } from '@/src/components/ui/ErrorWrapper';
import { Textarea } from '@/src/components/ui/Textarea';

const meta: Meta<typeof Textarea> = {
  tags: ['autodocs'],
  component: Textarea,
};

export default meta;
type Story = StoryObj<typeof Textarea>;

export const Primary: Story = {
  args: {
    placeholder: 'Placeholder text',
  },
  decorators: [
    (Story) => (
      <div className="w-[400px]">
        <ErrorWrapper name={'input'} error={undefined}>
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
          name={'input'}
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
