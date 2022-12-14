-- This script was generated by the Schema Diff utility in pgAdmin 4
-- For the circular dependencies, the order in which Schema Diff writes the objects is not very sophisticated
-- and may require manual changes to the script to ensure changes are applied in the correct order.
-- Please report an issue for any failure with the reproduction steps.

ALTER TABLE IF EXISTS public.profiles
    RENAME COLUMN address TO owner;

CREATE OR REPLACE FUNCTION public.get_profile_by_address(
	connected_address text)
    RETURNS SETOF profiles 
    LANGUAGE 'plpgsql'
    COST 100
    VOLATILE PARALLEL UNSAFE
    ROWS 1000

AS $BODY$
BEGIN
  RETURN QUERY SELECT p.*
  FROM profiles p
  INNER JOIN verifications v
  ON p.id = v.fid
  WHERE v.address ilike connected_address
  GROUP BY p.id;
END;
$BODY$;

ALTER FUNCTION public.get_profile_by_address(text)
    OWNER TO postgres;

GRANT EXECUTE ON FUNCTION public.get_profile_by_address(text) TO PUBLIC;

GRANT EXECUTE ON FUNCTION public.get_profile_by_address(text) TO anon;

GRANT EXECUTE ON FUNCTION public.get_profile_by_address(text) TO authenticated;

GRANT EXECUTE ON FUNCTION public.get_profile_by_address(text) TO postgres;

GRANT EXECUTE ON FUNCTION public.get_profile_by_address(text) TO service_role;