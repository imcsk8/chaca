-- Candidate reactions

CREATE TABLE IF NOT EXISTS candidate_reactions (
    reaction_id SERIAL PRIMARY KEY,
    candidate_id uuid  NOT NULL REFERENCES candidate(id) ON DELETE CASCADE,
    user_id uuid NOT NULL REFERENCES users(id) ON DELETE CASCADE,
    reaction_type reaction NOT NULL DEFAULT 'NA',  -- like, love, laugh, etc.
    created_at TIMESTAMP WITH TIME ZONE DEFAULT CURRENT_TIMESTAMP,
    
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

