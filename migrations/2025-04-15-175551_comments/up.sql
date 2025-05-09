-- Your SQL goes here

DROP TYPE IF EXISTS reaction CASCADE;
CREATE TYPE reaction AS
ENUM ('NA', 'LIKE','LOVE','LAUGH','DISLIKE','BAD','DANGER');

DROP TYPE IF EXISTS resource_type CASCADE;
CREATE TYPE resource_type AS
ENUM ('PROFILE', 'TRAJECTORY','MATTER','POSITION','SCHOOLING');

-- Comments

CREATE TABLE IF NOT EXISTS comments (
    comment_id SERIAL PRIMARY KEY,
    candidate_id UUID REFERENCES candidate(id) ON DELETE CASCADE,
    user_id uuid NOT NULL REFERENCES users(id) ON DELETE CASCADE,
    user_name TEXT NOT NULL, -- Denormalization for more fast queries
    content TEXT NOT NULL,
    parent_comment_id INTEGER REFERENCES comments(comment_id) ON DELETE CASCADE,
    resource_type resource_type NOT NULL DEFAULT 'PROFILE',
    created_at TIMESTAMP WITH TIME ZONE DEFAULT CURRENT_TIMESTAMP,
    updated_at TIMESTAMP WITH TIME ZONE,
    is_edited BOOLEAN DEFAULT FALSE,
    is_hidden BOOLEAN DEFAULT FALSE,
    likes_count INTEGER DEFAULT 0
);

CREATE INDEX IF NOT EXISTS idx_resource ON comments
USING btree
(
    resource_type
);

CREATE INDEX IF NOT EXISTS idx_user_id ON comments
USING btree
(
    user_id
);

CREATE INDEX IF NOT EXISTS idx_parent ON comments
USING btree
(
    parent_comment_id
);


CREATE INDEX IF NOT EXISTS idx_candidate ON comments
USING btree
(
    candidate_id
);

CREATE INDEX IF NOT EXISTS idx_candidate_user ON comments
USING btree
(
    candidate_id,
    user_id
);

CREATE INDEX IF NOT EXISTS idx_candidate_user_name ON comments
USING btree
(
    user_name
);

CREATE UNIQUE INDEX IF NOT EXISTS idx_candidate_user_comment ON comments
USING btree
(
    comment_id,
    candidate_id,
    user_id
);



CREATE TABLE IF NOT EXISTS comment_reactions (
    reaction_id SERIAL PRIMARY KEY,
    comment_id INTEGER NOT NULL REFERENCES comments(comment_id) ON DELETE CASCADE,
    user_id uuid NOT NULL REFERENCES users(id) ON DELETE CASCADE,
    reaction_type reaction NOT NULL DEFAULT 'NA',  -- like, love, laugh, etc.
    created_at TIMESTAMP WITH TIME ZONE DEFAULT CURRENT_TIMESTAMP,
    
    UNIQUE (comment_id, user_id, reaction_type)
);

CREATE UNIQUE INDEX IF NOT EXISTS idx_comment ON comment_reactions
USING btree
(
    comment_id
);

CREATE UNIQUE INDEX IF NOT EXISTS idx_comment_reactions_user ON comment_reactions
USING btree
(
    user_id
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
