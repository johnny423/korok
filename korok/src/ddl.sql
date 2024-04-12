-- Table for RFC
CREATE TABLE rfc (
    num INTEGER PRIMARY KEY,
    title VARCHAR,
    published_at TIMESTAMP
);

CREATE INDEX idx_published_at ON rfc (published_at);

-- Table for Authors
CREATE TABLE authors (
    rfc_num INTEGER REFERENCES rfc(num),
    author_name VARCHAR,
    FOREIGN KEY (rfc_num) REFERENCES rfc(num)
);

CREATE INDEX idx_rfc_num ON authors (rfc_num);

-- Table for RFC Section
CREATE TABLE rfc_section (
    id SERIAL PRIMARY KEY,
    rfc_num INTEGER REFERENCES rfc(num),
    index INTEGER,
    content TEXT,
    row_start INTEGER,
    row_end INTEGER,
    indentation INTEGER
);

CREATE INDEX idx_rfc_num_section ON rfc_section (rfc_num);

-- Table for Token
CREATE TABLE token (
    id SERIAL PRIMARY KEY,
    token VARCHAR,
    stem VARCHAR
);

CREATE INDEX idx_token ON token (token);

-- Table for Token Position
CREATE TABLE token_position (
    id SERIAL PRIMARY KEY,
    token_id INTEGER REFERENCES token(id),
    rfc_num INTEGER REFERENCES rfc(num),
    page INTEGER,
    row INTEGER,
    section_id INTEGER REFERENCES rfc_section(id)
);

CREATE INDEX idx_token_id ON token_position (token_id);
CREATE INDEX idx_rfc_num_token_position ON token_position (rfc_num);
CREATE INDEX idx_section_id ON token_position (section_id);

-- Table for Token Group
CREATE TABLE token_group (
    id SERIAL PRIMARY KEY,
    group_name VARCHAR
);

CREATE INDEX idx_group_name ON token_group (group_name);

-- Table for Token to Group
CREATE TABLE token_to_group (
    token_id INTEGER REFERENCES token(id),
    group_id INTEGER REFERENCES token_group(id),
    PRIMARY KEY (token_id, group_id)
);

-- Table for Linguistic Phrase
CREATE TABLE linguistic_phrase (
    id SERIAL PRIMARY KEY,
    phrase_name VARCHAR UNIQUE
);

CREATE INDEX idx_phrase_name ON linguistic_phrase (phrase_name);

-- Table for Linguistic Phrase Tokens
CREATE TABLE linguistic_phrase_tokens (
    id SERIAL PRIMARY KEY,
    phrase_id INTEGER REFERENCES linguistic_phrase(id),
    token_id INTEGER REFERENCES token(id),
    index INTEGER,
    UNIQUE (phrase_id, token_id)
);

-- Table for Phrase Occurrence
CREATE TABLE phrase_occurrence (
    id SERIAL PRIMARY KEY,
    phrase_id INTEGER REFERENCES linguistic_phrase(id),
    rfc_num INTEGER REFERENCES rfc(num),
    section_id INTEGER REFERENCES rfc_section(id),
    page INTEGER,
    row_start INTEGER,
    row_end INTEGER,
    occurrence_count INTEGER
);

CREATE INDEX idx_phrase_id ON phrase_occurrence (phrase_id);
CREATE INDEX idx_rfc_num_occurrence ON phrase_occurrence (rfc_num);
CREATE INDEX idx_section_id_occurrence ON phrase_occurrence (section_id);
