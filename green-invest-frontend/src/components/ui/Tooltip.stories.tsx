//green-invest

import type { Meta, StoryObj } from '@storybook/react';

import {
  Tooltip,
  TooltipProvider,
  TooltipTrigger,
  TooltipContent,
} from '@/src/components/ui/Tooltip';
import { Button } from '@/src/components/ui/Button';

const meta: Meta<typeof Tooltip> = {
  tags: ['autodocs'],
  component: Tooltip,
};

export default meta;
type Story = StoryObj<typeof meta>;

export const Primary: Story = {
  args: {
    children: (
      <>
        <TooltipTrigger asChild>
          <Button variant="default">Hover over me!</Button>
        </TooltipTrigger>
        <TooltipContent>
          <p>This is an example tooltip</p>
        </TooltipContent>
      </>
    ),
  },
  decorators: [
    (Story) => (
      <TooltipProvider>
        <Story />
      </TooltipProvider>
    ),
  ],
};

export const NoDelay: Story = {
  args: Primary.args,
  decorators: [
    (Story) => (
      <TooltipProvider delayDuration={0}>
        <Story />
      </TooltipProvider>
    ),
  ],
};
