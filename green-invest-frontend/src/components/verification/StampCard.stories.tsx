//green-invest

import type { Meta, StoryObj } from '@storybook/react';
import StampCard from './StampCard';
import { BigNumber } from 'ethers';
import { FaGithub } from 'react-icons/fa';

const meta = {
  component: StampCard,
  tags: ['autodocs'],
  argTypes: {},
} satisfies Meta<typeof StampCard>;

export default meta;
type Story = StoryObj<typeof meta>;

const stampInfo = {
  id: 'github',
  displayName: 'GitHub',
  url: 'https://github.com/',
  icon: <FaGithub className="h-6 w-6 shrink-0" />,
};

export const Verified: Story = {
  args: {
    stampInfo,
    stamp: ['github', '0x0', [BigNumber.from(Math.floor(Date.now() / 1000))]],
    thresholdHistory: [[BigNumber.from(0), BigNumber.from(60)]],
    verify: () => {},
    isError: false,
  },
};

export const Expired: Story = {
  args: {
    stampInfo,
    stamp: ['github', '0x0', [BigNumber.from(Math.floor(Date.now() / 1000))]],
    thresholdHistory: [[BigNumber.from(0), BigNumber.from(0)]],
    verify: () => {},
    isError: false,
  },
};

export const Unverified: Story = {
  args: {
    stampInfo,
    stamp: ['github', '0x0', []],
    thresholdHistory: [[BigNumber.from(0), BigNumber.from(60)]],
    verify: () => {},
    isError: false,
  },
};
