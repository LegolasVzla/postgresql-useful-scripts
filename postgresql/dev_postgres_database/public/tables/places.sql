CREATE TABLE public.places(
  id serial primary key,
  name character varying(100) NOT NULL,
  created_at timestamp without time zone NOT NULL,
  updated_at timestamp without time zone NOT NULL,
  is_active boolean DEFAULT true,
  is_deleted boolean DEFAULT false
);