//green-invest

import type { Meta, StoryObj } from '@storybook/react';

import {
  Actions,
  ProposalFormActions,
} from '@/src/components/newProposal/steps/Actions';
import { NewProposalFormProvider } from '@/src/pages/NewProposal';
import { emptyWithdrawData } from '@/src/components/newProposal/actions/WithdrawAssetsInput';
import { emptyMintData } from '@/src/components/newProposal/actions/MintTokensInput';
import { emptyMergeData } from '../actions/MergePRInput';

const meta: Meta<typeof Actions> = {
  component: Actions,
  tags: ['autodocs'],
};

export default meta;
type Story = StoryObj<typeof Actions>;

const FormProviderDecorator = (Story: any, options: any) => {
  const { args } = options;

  return (
    <NewProposalFormProvider step={3} dataStep3={args.data}>
      <Story />
    </NewProposalFormProvider>
  );
};

export const Primary: Story = {
  args: {
    data: { actions: [emptyMintData, emptyWithdrawData, emptyMergeData] },
  },
  decorators: [FormProviderDecorator],
};

export const Empty: Story = {
  args: { data: { actions: [] } },
  decorators: [FormProviderDecorator],
};
