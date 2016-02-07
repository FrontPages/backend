--
-- PostgreSQL database dump
--

SET statement_timeout = 0;
SET lock_timeout = 0;
SET client_encoding = 'UTF8';
SET standard_conforming_strings = on;
SET check_function_bodies = false;
SET client_min_messages = warning;

--
-- Name: plpgsql; Type: EXTENSION; Schema: -; Owner: -
--

CREATE EXTENSION IF NOT EXISTS plpgsql WITH SCHEMA pg_catalog;


--
-- Name: EXTENSION plpgsql; Type: COMMENT; Schema: -; Owner: -
--

COMMENT ON EXTENSION plpgsql IS 'PL/pgSQL procedural language';


SET search_path = public, pg_catalog;

SET default_tablespace = '';

SET default_with_oids = false;

--
-- Name: collection_snapshots; Type: TABLE; Schema: public; Owner: -; Tablespace: 
--

CREATE TABLE collection_snapshots (
    id integer NOT NULL,
    collection_id integer,
    snapshot_id integer,
    created_at timestamp without time zone NOT NULL,
    updated_at timestamp without time zone NOT NULL
);


--
-- Name: collection_snapshots_id_seq; Type: SEQUENCE; Schema: public; Owner: -
--

CREATE SEQUENCE collection_snapshots_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


--
-- Name: collection_snapshots_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: -
--

ALTER SEQUENCE collection_snapshots_id_seq OWNED BY collection_snapshots.id;


--
-- Name: collections; Type: TABLE; Schema: public; Owner: -; Tablespace: 
--

CREATE TABLE collections (
    id integer NOT NULL,
    title character varying,
    subtitle character varying,
    permalink character varying,
    created_at timestamp without time zone NOT NULL,
    updated_at timestamp without time zone NOT NULL
);


--
-- Name: collections_id_seq; Type: SEQUENCE; Schema: public; Owner: -
--

CREATE SEQUENCE collections_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


--
-- Name: collections_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: -
--

ALTER SEQUENCE collections_id_seq OWNED BY collections.id;


--
-- Name: headlines; Type: TABLE; Schema: public; Owner: -; Tablespace: 
--

CREATE TABLE headlines (
    id integer NOT NULL,
    title character varying(255),
    url character varying(255),
    created_at timestamp without time zone,
    updated_at timestamp without time zone,
    snapshot_id integer,
    story_id integer
);


--
-- Name: headlines_id_seq; Type: SEQUENCE; Schema: public; Owner: -
--

CREATE SEQUENCE headlines_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


--
-- Name: headlines_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: -
--

ALTER SEQUENCE headlines_id_seq OWNED BY headlines.id;


--
-- Name: schema_migrations; Type: TABLE; Schema: public; Owner: -; Tablespace: 
--

CREATE TABLE schema_migrations (
    version character varying(255) NOT NULL
);


--
-- Name: sites; Type: TABLE; Schema: public; Owner: -; Tablespace: 
--

CREATE TABLE sites (
    id integer NOT NULL,
    name character varying(255),
    url character varying(255),
    selector character varying(255),
    shortcode character varying(255),
    created_at timestamp without time zone,
    updated_at timestamp without time zone,
    script text
);


--
-- Name: sites_id_seq; Type: SEQUENCE; Schema: public; Owner: -
--

CREATE SEQUENCE sites_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


--
-- Name: sites_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: -
--

ALTER SEQUENCE sites_id_seq OWNED BY sites.id;


--
-- Name: snapshots; Type: TABLE; Schema: public; Owner: -; Tablespace: 
--

CREATE TABLE snapshots (
    id integer NOT NULL,
    filename character varying(255),
    height integer,
    width integer,
    size integer,
    site_id integer,
    created_at timestamp without time zone,
    updated_at timestamp without time zone,
    thumbnail character varying,
    keyframe boolean DEFAULT true,
    searchable_headlines text
);


--
-- Name: snapshots_id_seq; Type: SEQUENCE; Schema: public; Owner: -
--

CREATE SEQUENCE snapshots_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


--
-- Name: snapshots_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: -
--

ALTER SEQUENCE snapshots_id_seq OWNED BY snapshots.id;


--
-- Name: stories; Type: TABLE; Schema: public; Owner: -; Tablespace: 
--

CREATE TABLE stories (
    id integer NOT NULL,
    url character varying,
    site_id integer,
    created_at timestamp without time zone NOT NULL,
    updated_at timestamp without time zone NOT NULL
);


--
-- Name: stories_id_seq; Type: SEQUENCE; Schema: public; Owner: -
--

CREATE SEQUENCE stories_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


--
-- Name: stories_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: -
--

ALTER SEQUENCE stories_id_seq OWNED BY stories.id;


--
-- Name: id; Type: DEFAULT; Schema: public; Owner: -
--

ALTER TABLE ONLY collection_snapshots ALTER COLUMN id SET DEFAULT nextval('collection_snapshots_id_seq'::regclass);


--
-- Name: id; Type: DEFAULT; Schema: public; Owner: -
--

ALTER TABLE ONLY collections ALTER COLUMN id SET DEFAULT nextval('collections_id_seq'::regclass);


--
-- Name: id; Type: DEFAULT; Schema: public; Owner: -
--

ALTER TABLE ONLY headlines ALTER COLUMN id SET DEFAULT nextval('headlines_id_seq'::regclass);


--
-- Name: id; Type: DEFAULT; Schema: public; Owner: -
--

ALTER TABLE ONLY sites ALTER COLUMN id SET DEFAULT nextval('sites_id_seq'::regclass);


--
-- Name: id; Type: DEFAULT; Schema: public; Owner: -
--

ALTER TABLE ONLY snapshots ALTER COLUMN id SET DEFAULT nextval('snapshots_id_seq'::regclass);


--
-- Name: id; Type: DEFAULT; Schema: public; Owner: -
--

ALTER TABLE ONLY stories ALTER COLUMN id SET DEFAULT nextval('stories_id_seq'::regclass);


--
-- Name: collection_snapshots_pkey; Type: CONSTRAINT; Schema: public; Owner: -; Tablespace: 
--

ALTER TABLE ONLY collection_snapshots
    ADD CONSTRAINT collection_snapshots_pkey PRIMARY KEY (id);


--
-- Name: collections_pkey; Type: CONSTRAINT; Schema: public; Owner: -; Tablespace: 
--

ALTER TABLE ONLY collections
    ADD CONSTRAINT collections_pkey PRIMARY KEY (id);


--
-- Name: headlines_pkey; Type: CONSTRAINT; Schema: public; Owner: -; Tablespace: 
--

ALTER TABLE ONLY headlines
    ADD CONSTRAINT headlines_pkey PRIMARY KEY (id);


--
-- Name: sites_pkey; Type: CONSTRAINT; Schema: public; Owner: -; Tablespace: 
--

ALTER TABLE ONLY sites
    ADD CONSTRAINT sites_pkey PRIMARY KEY (id);


--
-- Name: snapshots_pkey; Type: CONSTRAINT; Schema: public; Owner: -; Tablespace: 
--

ALTER TABLE ONLY snapshots
    ADD CONSTRAINT snapshots_pkey PRIMARY KEY (id);


--
-- Name: stories_pkey; Type: CONSTRAINT; Schema: public; Owner: -; Tablespace: 
--

ALTER TABLE ONLY stories
    ADD CONSTRAINT stories_pkey PRIMARY KEY (id);


--
-- Name: index_collection_snapshots_on_collection_id; Type: INDEX; Schema: public; Owner: -; Tablespace: 
--

CREATE INDEX index_collection_snapshots_on_collection_id ON collection_snapshots USING btree (collection_id);


--
-- Name: index_collection_snapshots_on_snapshot_id; Type: INDEX; Schema: public; Owner: -; Tablespace: 
--

CREATE INDEX index_collection_snapshots_on_snapshot_id ON collection_snapshots USING btree (snapshot_id);


--
-- Name: index_collections_on_permalink; Type: INDEX; Schema: public; Owner: -; Tablespace: 
--

CREATE UNIQUE INDEX index_collections_on_permalink ON collections USING btree (permalink);


--
-- Name: index_headlines_on_created_at; Type: INDEX; Schema: public; Owner: -; Tablespace: 
--

CREATE INDEX index_headlines_on_created_at ON headlines USING btree (created_at);


--
-- Name: index_headlines_on_snapshot_id; Type: INDEX; Schema: public; Owner: -; Tablespace: 
--

CREATE INDEX index_headlines_on_snapshot_id ON headlines USING btree (snapshot_id);


--
-- Name: index_headlines_on_story_id; Type: INDEX; Schema: public; Owner: -; Tablespace: 
--

CREATE INDEX index_headlines_on_story_id ON headlines USING btree (story_id);


--
-- Name: index_on_title; Type: INDEX; Schema: public; Owner: -; Tablespace: 
--

CREATE INDEX index_on_title ON headlines USING gin (to_tsvector('english'::regconfig, COALESCE((title)::text, ''::text)));


--
-- Name: index_snapshots_on_created_at; Type: INDEX; Schema: public; Owner: -; Tablespace: 
--

CREATE INDEX index_snapshots_on_created_at ON snapshots USING btree (created_at DESC) WHERE (keyframe = true);


--
-- Name: index_snapshots_on_site_id; Type: INDEX; Schema: public; Owner: -; Tablespace: 
--

CREATE INDEX index_snapshots_on_site_id ON snapshots USING btree (site_id);


--
-- Name: index_stories_on_site_id; Type: INDEX; Schema: public; Owner: -; Tablespace: 
--

CREATE INDEX index_stories_on_site_id ON stories USING btree (site_id);


--
-- Name: unique_schema_migrations; Type: INDEX; Schema: public; Owner: -; Tablespace: 
--

CREATE UNIQUE INDEX unique_schema_migrations ON schema_migrations USING btree (version);


--
-- Name: fk_rails_19e4328475; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY stories
    ADD CONSTRAINT fk_rails_19e4328475 FOREIGN KEY (site_id) REFERENCES sites(id);


--
-- Name: fk_rails_2aa8ac3134; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY collection_snapshots
    ADD CONSTRAINT fk_rails_2aa8ac3134 FOREIGN KEY (snapshot_id) REFERENCES snapshots(id);


--
-- Name: fk_rails_da6ee373ec; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY collection_snapshots
    ADD CONSTRAINT fk_rails_da6ee373ec FOREIGN KEY (collection_id) REFERENCES collections(id);


--
-- PostgreSQL database dump complete
--

SET search_path TO "$user",public;

INSERT INTO schema_migrations (version) VALUES ('20151228023949');

INSERT INTO schema_migrations (version) VALUES ('20151228025516');

INSERT INTO schema_migrations (version) VALUES ('20151229150810');

INSERT INTO schema_migrations (version) VALUES ('20151229151300');

INSERT INTO schema_migrations (version) VALUES ('20160101025142');

INSERT INTO schema_migrations (version) VALUES ('20160102043656');

INSERT INTO schema_migrations (version) VALUES ('20160102043934');

INSERT INTO schema_migrations (version) VALUES ('20160102054451');

INSERT INTO schema_migrations (version) VALUES ('20160105031622');

INSERT INTO schema_migrations (version) VALUES ('20160106032737');

INSERT INTO schema_migrations (version) VALUES ('20160113141156');

INSERT INTO schema_migrations (version) VALUES ('20160203162530');

INSERT INTO schema_migrations (version) VALUES ('20160203162924');

INSERT INTO schema_migrations (version) VALUES ('20160204193416');

INSERT INTO schema_migrations (version) VALUES ('20160206223500');

INSERT INTO schema_migrations (version) VALUES ('20160207165941');

