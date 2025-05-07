-- Candidate reactions

CREATE TABLE IF NOT EXISTS candidate_reactions (
    reaction_id SERIAL PRIMARY KEY,
    candidate_id uuid  NOT NULL REFERENCES candidate(id) ON DELETE CASCADE,
    user_id uuid NOT NULL REFERENCES users(id) ON DELETE CASCADE,
    reaction_type reaction NOT NULL DEFAULT 'NA',  -- like, love, laugh, etc.
    created_at TIMESTAMP WITH TIME ZONE DEFAULT CURRENT_TIMESTAMP,
    updated_at TIMESTAMP WITH TIME ZONE NOT NULL DEFAULT NOW(),
    is_edited BOOLEAN DEFAULT FALSE,
    
    UNIQUE (candidate_id, user_id, reaction_type)
);

CREATE INDEX IF NOT EXISTS idx_candidate ON candidate_reactions
USING btree
(
    candidate_id
);

CREATE INDEX IF NOT EXISTS idx_candidate_reactions_user ON candidate_reactions
USING btree
(
    user_id
);

CREATE UNIQUE INDEX IF NOT EXISTS idx_candidate_reactions_user_candidate ON candidate_reactions
USING btree
(
    user_id,
    candidate_id
);

CREATE INDEX IF NOT EXISTS idx_candidate_reactions_type ON candidate_reactions
USING btree
(
    reaction_type
);

-- *****************************************************************************
--
--                              F U N C T I O N S
--
-- *****************************************************************************

-- Trigger to update comments.updated_at whenever a reaction is modified
CREATE OR REPLACE FUNCTION update_reaction_timestamp()
RETURNS TRIGGER AS $$
BEGIN
    NEW.updated_at = CURRENT_TIMESTAMP;
    NEW.is_edited = TRUE;
    RETURN NEW;
END;
$$ LANGUAGE plpgsql;

CREATE TRIGGER update_reaction_timestamp_trigger
BEFORE UPDATE ON candidate_reactions
FOR EACH ROW
WHEN (OLD.reaction_type IS DISTINCT FROM NEW.reaction_type)
EXECUTE FUNCTION update_reaction_timestamp();
