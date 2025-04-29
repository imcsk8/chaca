-- This file should undo anything in `up.sql`
DROP TABLE IF EXISTS comments CASCADE;
DROP TABLE IF EXISTS comment_reactions;
DROP TYPE IF EXISTS reaction CASCADE;
