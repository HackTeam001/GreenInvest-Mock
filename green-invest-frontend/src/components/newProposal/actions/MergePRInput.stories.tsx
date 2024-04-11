//green-invest

import type { Meta, StoryObj } from '@storybook/react';

import { MergePRInput } from './MergePRInput';
import { ProposalFormActions } from '../steps/Actions';
import { NewProposalFormProvider } from '@/src/pages/NewProposal';

const FormProviderDecoratorFactory = (data: ProposalFormActions): any => {
  // eslint-disable-next-line react/display-name
  return (Story: any) => (
    <NewProposalFormProvider step={3} dataStep3={data}>
      <Story />
    </NewProposalFormProvider>
  );
};

const meta: Meta<typeof MergePRInput> = {
  component: MergePRInput,
  tags: ['autodocs'],
  decorators: [FormProviderDecoratorFactory({ actions: [] })],
};

export default meta;
type Story = StoryObj<typeof MergePRInput>;

export const Primary: Story = {
  args: {
    register: (() => {}) as any,
    prefix: 'actions.1.',
    errors: {},
    onRemove() {},
  },
};
