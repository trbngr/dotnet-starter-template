import type { Meta, StoryObj } from 'storybook/internal/types';
import { Users } from './users';
import { expect } from 'storybook/test';

const meta: Meta<typeof Users> = {
  component: Users,
  title: 'Users',
};
export default meta;
type Story = StoryObj<typeof Users>;

export const Primary = {
  args: {},
};

export const Heading: Story = {
  args: {},
  play: async ({ canvas }) => {
    await expect(canvas.getByText(/Welcome to Users!/gi)).toBeTruthy();
  },
};
