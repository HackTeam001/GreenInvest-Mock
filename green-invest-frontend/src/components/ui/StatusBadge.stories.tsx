//green-invest

import type { Meta, StoryObj } from '@storybook/react';
import { StatusBadge } from '@/src/components/ui/StatusBadge';
import Check from '@/src/components/icons/Check';
import Activity from '@/src/components/icons/Activity';
import { HiOutlineClock, HiXMark } from 'react-icons/hi2';

const meta = {
  component: StatusBadge,
  tags: ['autodocs'],
  argTypes: {
    icon: {
      table: {
        disable: true,
      },
    },
  },
} satisfies Meta<typeof StatusBadge>;

export default meta;
type Story = StoryObj<typeof meta>;

export const Primary: Story = {
  args: {
    variant: 'primary',
    icon: Activity,
    size: 'md',
    text: 'Active',
  },
};

export const Secondary: Story = {
  args: {
    variant: 'secondary',
    icon: HiOutlineClock,
    size: 'md',
    text: 'Pending',
  },
};

export const Success: Story = {
  args: {
    variant: 'success',
    icon: Check,
    size: 'md',
    text: 'Succeeded',
  },
};

export const Destructive: Story = {
  args: {
    variant: 'destructive',
    icon: HiXMark,
    size: 'md',
    text: 'Defeated',
  },
};
