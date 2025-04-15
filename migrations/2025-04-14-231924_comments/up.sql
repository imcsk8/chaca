-- Your SQL goes here

DROP TYPE IF EXISTS reaction CASCADE;
CREATE TYPE reaction AS
ENUM ('LIKE','LOVE','LAUGH','DISLIKE','BAD','DANGER');


-- Comments

CREATE TABLE IF NOT EXISTS comments (
    comment_id SERIAL PRIMARY KEY,
    user_id uuid NOT NULL REFERENCES users(id) ON DELETE CASCADE,
    content TEXT NOT NULL,
    parent_comment_id INTEGER REFERENCES comments(comment_id) ON DELETE CASCADE,
    resource_id VARCHAR(100) NOT NULL,  -- ID of the resource being commented on (article, post, etc.)
    resource_type VARCHAR(50) NOT NULL,  -- Type of resource (article, video, product, etc.)
    created_at TIMESTAMP WITH TIME ZONE DEFAULT CURRENT_TIMESTAMP,
    updated_at TIMESTAMP WITH TIME ZONE,
    is_edited BOOLEAN DEFAULT FALSE,
    is_hidden BOOLEAN DEFAULT FALSE,
    likes_count INTEGER DEFAULT 0,
    
    INDEX idx_resource (resource_type, resource_id),
    INDEX idx_user (user_id),
    INDEX idx_parent (parent_comment_id)
);

CREATE TABLE IF NOT EXISTS comment_reactions (
    reaction_id SERIAL PRIMARY KEY,
    comment_id INTEGER NOT NULL REFERENCES comments(comment_id) ON DELETE CASCADE,
    user_id INTEGER NOT NULL REFERENCES users(user_id) ON DELETE CASCADE,
    reaction_type reaction NOT NULL,  -- like, love, laugh, etc.
    created_at TIMESTAMP WITH TIME ZONE DEFAULT CURRENT_TIMESTAMP,
    
    UNIQUE (comment_id, user_id, reaction_type),
    INDEX idx_comment (comment_id),
    INDEX idx_user (user_id)
);


-- *****************************************************************************
--
--                              F U N C T I O N S
--
-- *****************************************************************************

-- Trigger to update comments.updated_at whenever a comment is modified
CREATE OR REPLACE FUNCTION update_comment_timestamp()
RETURNS TRIGGER AS $$
BEGIN
    NEW.updated_at = CURRENT_TIMESTAMP;
    NEW.is_edited = TRUE;
    RETURN NEW;
END;
$$ LANGUAGE plpgsql;

CREATE TRIGGER update_comment_timestamp_trigger
BEFORE UPDATE ON comments
FOR EACH ROW
WHEN (OLD.content IS DISTINCT FROM NEW.content)
EXECUTE FUNCTION update_comment_timestamp();
