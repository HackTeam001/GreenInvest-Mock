//green-invest

import {
  AccordionContent,
  AccordionItem,
  AccordionTrigger,
} from '@/src/components/ui/Accordion';
import { AccordionItemProps } from '@radix-ui/react-accordion';
import { createElement } from 'react';
import { IconType } from 'react-icons';

interface ActionWrapperProps extends AccordionItemProps {
  icon: IconType;
  title: string;
  description: string;
}

/**
 * General wrapper for a proposal action that includes an icon and title inside of an accordion
 * @param props.icon Icon to show in the AccordionTrigger
 * @param props.title Title to show in the AccordionTrigger
 * @param props.description Description of the action
 * @param props.children Children to show in the AccordionContent
 * @returns A wrapper for a proposal action constituting an AccordionTrigger and AccordionContent component
 */
const ActionWrapper = ({
  icon,
  title,
  description,
  children,
  ...props
}: ActionWrapperProps) => {
  const iconNode = createElement(icon, {
    className: 'h-5 w-5 shrink-0 text-popover-foreground/80',
  });

  return (
    <AccordionItem {...props}>
      <AccordionTrigger className="flex flex-row items-center gap-x-2">
        {iconNode}
        <p className="text-lg">{title}</p>
      </AccordionTrigger>
      <AccordionContent className="space-y-4">
        <p className="text-popover-foreground/80">{description}</p>
        {/* Only render a seperator if children were provided */}
        {children && (
          <>
            <ActionContentSeparator />
            {children}
          </>
        )}
      </AccordionContent>
    </AccordionItem>
  );
};

export const ActionContentSeparator = () => {
  return <hr className="border-2 border-accent" />;
};

export default ActionWrapper;
