//green-invest

import type { Meta, StoryObj } from '@storybook/react';

import {
  Toast,
  ToastAction,
  ToastClose,
  ToastDescription,
  ToastProvider,
  ToastTitle,
  ToastViewport,
} from '@/src/components/ui/Toast';

const meta: Meta<typeof Toast> = {
  component: Toast,
  tags: ['autodocs'],
  argTypes: {
    children: {
      table: {
        disable: true,
      },
    },
    asChild: {
      table: {
        disable: true,
      },
    },
  },
};

export default meta;
type Story = StoryObj<typeof meta>;

const toastProviderDecorator = (Story: any) => (
  <ToastProvider>
    <Story />
    <ToastViewport />
  </ToastProvider>
);

export const Default: Story = {
  args: {
    variant: 'default',
    duration: Infinity,
    children: (
      <>
        <div>
          <ToastTitle>Toast title</ToastTitle>
        </div>
        <ToastClose />
      </>
    ),
  },
  decorators: [toastProviderDecorator],
};

export const WithDescription: Story = {
  args: {
    variant: 'default',
    duration: Infinity,
    children: (
      <>
        <div>
          <ToastTitle>Toast title</ToastTitle>
          <ToastDescription>Toast description</ToastDescription>
        </div>
        <ToastClose />
      </>
    ),
  },
  decorators: [toastProviderDecorator],
};

export const Error: Story = {
  args: {
    variant: 'error',
    duration: Infinity,
    children: (
      <>
        <div>
          <ToastTitle>Toast title</ToastTitle>
        </div>
        <ToastClose />
      </>
    ),
  },
  decorators: [toastProviderDecorator],
};

export const Success: Story = {
  args: {
    variant: 'success',
    duration: Infinity,
    children: (
      <>
        <div>
          <ToastTitle>Toast title</ToastTitle>
        </div>
        <ToastClose />
      </>
    ),
  },
  decorators: [toastProviderDecorator],
};

export const Loading: Story = {
  args: {
    variant: 'loading',
    duration: Infinity,
    children: (
      <>
        <div>
          <ToastTitle>Toast title</ToastTitle>
        </div>
        <ToastClose />
      </>
    ),
  },
  decorators: [toastProviderDecorator],
};

export const WithAction: Story = {
  args: {
    variant: 'default',
    duration: Infinity,
    className: 'py-2',
    children: (
      <>
        <div className="space-y-1">
          <ToastTitle>Toast title</ToastTitle>
          <ToastAction altText={'Click me'}>Click me!</ToastAction>
        </div>
        <ToastClose />
      </>
    ),
  },
  decorators: [toastProviderDecorator],
};
