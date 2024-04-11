//green-invest

import { StoryFn } from '@storybook/react';
import { ReactElement, ReactNode, FC } from 'react';
import { FormProvider, useForm } from 'react-hook-form';

const StorybookFormProvider: FC<{ children: ReactNode; options: any }> = ({
  children,
  options,
}) => {
  const { parameters } = options;
  const methods = useForm({ defaultValues: parameters.defaultValues });
  return (
    <FormProvider {...methods}>
      <form>{children}</form>
    </FormProvider>
  );
};

export const withReactHookForm = (
  Story: FC,
  options: any
): ReturnType<StoryFn<ReactElement>> => (
  <StorybookFormProvider options={options}>
    <Story />
  </StorybookFormProvider>
);
