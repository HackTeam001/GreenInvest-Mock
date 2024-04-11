//green-invest

import type { Meta, StoryObj } from '@storybook/react';
import {
  Select,
  SelectContent,
  SelectGroup,
  SelectItem,
  SelectLabel,
  SelectSeparator,
  SelectTrigger,
  SelectValue,
} from '@/src/components/ui/Select';

const meta: Meta<typeof Select> = {
  tags: ['autodocs'],
  component: Select,
  argTypes: {
    children: {
      table: {
        disable: true,
      },
    },
  },
};

export default meta;
type Story = StoryObj<typeof Select>;

export const Primary: Story = {
  args: {
    defaultValue: 'MATIC',
    children: (
      <>
        <SelectTrigger>
          <SelectValue placeholder="Token" />
        </SelectTrigger>
        <SelectContent>
          <SelectGroup>
            <SelectLabel>ERC20 Tokens</SelectLabel>
            <SelectItem value={'ETH'}>ETH</SelectItem>
            <SelectItem value={'MATIC'}>MATIC</SelectItem>
          </SelectGroup>
          <SelectSeparator />
          <SelectGroup>
            <SelectLabel>ERC721 Tokens</SelectLabel>
            <SelectItem value={'BRAINED'}>BRAINED</SelectItem>
          </SelectGroup>
        </SelectContent>
      </>
    ),
  },
  decorators: [
    (Story) => (
      <div className="w-[400px]">
        <Story />
      </div>
    ),
  ],
};
