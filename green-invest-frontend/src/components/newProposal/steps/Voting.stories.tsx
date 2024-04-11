//green-invest
import type { Meta, StoryObj } from '@storybook/react';
import { NewProposalFormProvider } from '@/src/pages/NewProposal';

import { Voting } from './Voting';

const meta: Meta<typeof Voting> = {
  component: Voting,
  tags: ['autodocs'],
};

export default meta;
type Story = StoryObj<typeof Voting>;

const FormProviderDecorator = (Story: any, options: any) => {
  const { args } = options;

  return (
    <NewProposalFormProvider step={2} dataStep2={args.data}>
      <Story />
    </NewProposalFormProvider>
  );
};

export const Primary: Story = {
  args: {
    data: {
      option: 'yes-no-abstain',
      start_time_type: 'now',
      end_time_type: 'duration',
      duration_minutes: 30,
      duration_hours: 3,
      duration_days: 1,
    },
  },
  decorators: [FormProviderDecorator],
};

export const CustomStartTime: Story = {
  args: {
    data: {
      option: 'yes-no-abstain',
      start_time_type: 'custom',
      custom_start_date: '2345-01-23',
      custom_start_time: '12:34',
      custom_start_timezone: 'UTC+1',
      end_time_type: 'duration',
      duration_minutes: 30,
      duration_hours: 3,
      duration_days: 1,
    },
  },
  decorators: [FormProviderDecorator],
};

export const BothCustomTime: Story = {
  args: {
    data: {
      option: 'yes-no-abstain',
      start_time_type: 'custom',
      custom_start_date: '2345-01-23',
      custom_start_time: '12:34',
      custom_start_timezone: 'UTC+1',
      end_time_type: 'end-custom',
      custom_end_date: '2400-01-23',
      custom_end_time: '15:15',
      custom_end_timezone: 'UTC+2',
    },
  },
  decorators: [FormProviderDecorator],
};
