--
-- PostgreSQL database dump
--

-- Dumped from database version 11.5
-- Dumped by pg_dump version 11.2

SET statement_timeout = 0;
SET lock_timeout = 0;
SET idle_in_transaction_session_timeout = 0;
SET client_encoding = 'UTF8';
SET standard_conforming_strings = on;
SELECT pg_catalog.set_config('search_path', '', false);
SET check_function_bodies = false;
SET client_min_messages = warning;
SET row_security = off;

SET default_tablespace = '';

SET default_with_oids = false;

--
-- Name: collection_snapshots; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE public.collection_snapshots (
    id integer NOT NULL,
    collection_id integer,
    snapshot_id integer,
    created_at timestamp without time zone NOT NULL,
    updated_at timestamp without time zone NOT NULL
);


--
-- Name: collection_snapshots_id_seq; Type: SEQUENCE; Schema: public; Owner: -
--

CREATE SEQUENCE public.collection_snapshots_id_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


--
-- Name: collection_snapshots_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: -
--

ALTER SEQUENCE public.collection_snapshots_id_seq OWNED BY public.collection_snapshots.id;


--
-- Name: collections; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE public.collections (
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

CREATE SEQUENCE public.collections_id_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


--
-- Name: collections_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: -
--

ALTER SEQUENCE public.collections_id_seq OWNED BY public.collections.id;


--
-- Name: headlines; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE public.headlines (
    id integer NOT NULL,
    title character varying,
    url character varying,
    created_at timestamp without time zone,
    updated_at timestamp without time zone,
    snapshot_id integer,
    story_id integer
);


--
-- Name: headlines_id_seq; Type: SEQUENCE; Schema: public; Owner: -
--

CREATE SEQUENCE public.headlines_id_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


--
-- Name: headlines_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: -
--

ALTER SEQUENCE public.headlines_id_seq OWNED BY public.headlines.id;


--
-- Name: schema_migrations; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE public.schema_migrations (
    version character varying NOT NULL
);


--
-- Name: sites; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE public.sites (
    id integer NOT NULL,
    name character varying,
    url character varying,
    selector character varying,
    shortcode character varying,
    created_at timestamp without time zone,
    updated_at timestamp without time zone,
    script text
);


--
-- Name: sites_id_seq; Type: SEQUENCE; Schema: public; Owner: -
--

CREATE SEQUENCE public.sites_id_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


--
-- Name: sites_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: -
--

ALTER SEQUENCE public.sites_id_seq OWNED BY public.sites.id;


--
-- Name: snapshots; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE public.snapshots (
    id integer NOT NULL,
    filename character varying,
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

CREATE SEQUENCE public.snapshots_id_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


--
-- Name: snapshots_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: -
--

ALTER SEQUENCE public.snapshots_id_seq OWNED BY public.snapshots.id;


--
-- Name: stories; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE public.stories (
    id integer NOT NULL,
    url character varying,
    site_id integer,
    created_at timestamp without time zone NOT NULL,
    updated_at timestamp without time zone NOT NULL
);


--
-- Name: stories_id_seq; Type: SEQUENCE; Schema: public; Owner: -
--

CREATE SEQUENCE public.stories_id_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


--
-- Name: stories_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: -
--

ALTER SEQUENCE public.stories_id_seq OWNED BY public.stories.id;


--
-- Name: collection_snapshots id; Type: DEFAULT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.collection_snapshots ALTER COLUMN id SET DEFAULT nextval('public.collection_snapshots_id_seq'::regclass);


--
-- Name: collections id; Type: DEFAULT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.collections ALTER COLUMN id SET DEFAULT nextval('public.collections_id_seq'::regclass);


--
-- Name: headlines id; Type: DEFAULT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.headlines ALTER COLUMN id SET DEFAULT nextval('public.headlines_id_seq'::regclass);


--
-- Name: sites id; Type: DEFAULT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.sites ALTER COLUMN id SET DEFAULT nextval('public.sites_id_seq'::regclass);


--
-- Name: snapshots id; Type: DEFAULT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.snapshots ALTER COLUMN id SET DEFAULT nextval('public.snapshots_id_seq'::regclass);


--
-- Name: stories id; Type: DEFAULT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.stories ALTER COLUMN id SET DEFAULT nextval('public.stories_id_seq'::regclass);


--
-- Name: collection_snapshots collection_snapshots_pkey; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.collection_snapshots
    ADD CONSTRAINT collection_snapshots_pkey PRIMARY KEY (id);


--
-- Name: collections collections_pkey; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.collections
    ADD CONSTRAINT collections_pkey PRIMARY KEY (id);


--
-- Name: headlines headlines_pkey; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.headlines
    ADD CONSTRAINT headlines_pkey PRIMARY KEY (id);


--
-- Name: sites sites_pkey; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.sites
    ADD CONSTRAINT sites_pkey PRIMARY KEY (id);


--
-- Name: snapshots snapshots_pkey; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.snapshots
    ADD CONSTRAINT snapshots_pkey PRIMARY KEY (id);


--
-- Name: stories stories_pkey; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.stories
    ADD CONSTRAINT stories_pkey PRIMARY KEY (id);


--
-- Name: index_collection_snapshots_on_collection_id; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX index_collection_snapshots_on_collection_id ON public.collection_snapshots USING btree (collection_id);


--
-- Name: index_collection_snapshots_on_snapshot_id; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX index_collection_snapshots_on_snapshot_id ON public.collection_snapshots USING btree (snapshot_id);


--
-- Name: index_collections_on_permalink; Type: INDEX; Schema: public; Owner: -
--

CREATE UNIQUE INDEX index_collections_on_permalink ON public.collections USING btree (permalink);


--
-- Name: index_headlines_on_created_at; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX index_headlines_on_created_at ON public.headlines USING btree (created_at);


--
-- Name: index_headlines_on_snapshot_id; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX index_headlines_on_snapshot_id ON public.headlines USING btree (snapshot_id);


--
-- Name: index_headlines_on_story_id; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX index_headlines_on_story_id ON public.headlines USING btree (story_id);


--
-- Name: index_on_title; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX index_on_title ON public.headlines USING gin (to_tsvector('english'::regconfig, COALESCE((title)::text, ''::text)));


--
-- Name: index_snapshots_on_created_at; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX index_snapshots_on_created_at ON public.snapshots USING btree (created_at DESC) WHERE (keyframe = true);


--
-- Name: index_snapshots_on_site_id; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX index_snapshots_on_site_id ON public.snapshots USING btree (site_id);


--
-- Name: index_stories_on_site_id; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX index_stories_on_site_id ON public.stories USING btree (site_id);


--
-- Name: index_stories_on_url; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX index_stories_on_url ON public.stories USING btree (url);


--
-- Name: unique_schema_migrations; Type: INDEX; Schema: public; Owner: -
--

CREATE UNIQUE INDEX unique_schema_migrations ON public.schema_migrations USING btree (version);


--
-- Name: stories fk_rails_19e4328475; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.stories
    ADD CONSTRAINT fk_rails_19e4328475 FOREIGN KEY (site_id) REFERENCES public.sites(id);


--
-- Name: collection_snapshots fk_rails_2aa8ac3134; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.collection_snapshots
    ADD CONSTRAINT fk_rails_2aa8ac3134 FOREIGN KEY (snapshot_id) REFERENCES public.snapshots(id);


--
-- Name: collection_snapshots fk_rails_da6ee373ec; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.collection_snapshots
    ADD CONSTRAINT fk_rails_da6ee373ec FOREIGN KEY (collection_id) REFERENCES public.collections(id);


--
-- PostgreSQL database dump complete
--

SET search_path TO "$user", public;

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

INSERT INTO schema_migrations (version) VALUES ('20191209112407');

