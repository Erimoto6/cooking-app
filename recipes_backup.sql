--
-- PostgreSQL database dump
--

\restrict CDEM5NrPrr4ZY9xQNaOn3KGDKagF4TPu0WJDWPK0oeKpnPGAxfgzn7Y6S0iqdYj

-- Dumped from database version 18.4
-- Dumped by pg_dump version 18.4

SET statement_timeout = 0;
SET lock_timeout = 0;
SET idle_in_transaction_session_timeout = 0;
SET transaction_timeout = 0;
SET client_encoding = 'UTF8';
SET standard_conforming_strings = on;
SELECT pg_catalog.set_config('search_path', '', false);
SET check_function_bodies = false;
SET xmloption = content;
SET client_min_messages = warning;
SET row_security = off;

--
-- Name: public; Type: SCHEMA; Schema: -; Owner: myuser
--

-- *not* creating schema, since initdb creates it


ALTER SCHEMA public OWNER TO myuser;

SET default_tablespace = '';

SET default_table_access_method = heap;

--
-- Name: favorites; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.favorites (
    user_id integer NOT NULL,
    recipe_id integer NOT NULL,
    created_at timestamp without time zone DEFAULT CURRENT_TIMESTAMP
);


ALTER TABLE public.favorites OWNER TO postgres;

--
-- Name: ingredients; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.ingredients (
    id integer NOT NULL,
    recipe_id integer,
    name text NOT NULL,
    quantity text
);


ALTER TABLE public.ingredients OWNER TO postgres;

--
-- Name: ingredients_id_seq; Type: SEQUENCE; Schema: public; Owner: postgres
--

CREATE SEQUENCE public.ingredients_id_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER SEQUENCE public.ingredients_id_seq OWNER TO postgres;

--
-- Name: ingredients_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: postgres
--

ALTER SEQUENCE public.ingredients_id_seq OWNED BY public.ingredients.id;


--
-- Name: recipe_folders; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.recipe_folders (
    id integer NOT NULL,
    user_id integer,
    folder_name text NOT NULL,
    created_at timestamp without time zone DEFAULT CURRENT_TIMESTAMP
);


ALTER TABLE public.recipe_folders OWNER TO postgres;

--
-- Name: recipe_folders_id_seq; Type: SEQUENCE; Schema: public; Owner: postgres
--

CREATE SEQUENCE public.recipe_folders_id_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER SEQUENCE public.recipe_folders_id_seq OWNER TO postgres;

--
-- Name: recipe_folders_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: postgres
--

ALTER SEQUENCE public.recipe_folders_id_seq OWNED BY public.recipe_folders.id;


--
-- Name: recipes; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.recipes (
    id integer NOT NULL,
    dish_id character varying(20),
    title text NOT NULL,
    description text,
    cuisine text,
    region text,
    category text,
    prep_time integer,
    cook_time integer,
    difficulty text,
    image_url text,
    user_id integer,
    created_at timestamp without time zone DEFAULT CURRENT_TIMESTAMP
);


ALTER TABLE public.recipes OWNER TO postgres;

--
-- Name: recipes_id_seq; Type: SEQUENCE; Schema: public; Owner: postgres
--

CREATE SEQUENCE public.recipes_id_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER SEQUENCE public.recipes_id_seq OWNER TO postgres;

--
-- Name: recipes_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: postgres
--

ALTER SEQUENCE public.recipes_id_seq OWNED BY public.recipes.id;


--
-- Name: shopping_list; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.shopping_list (
    id integer NOT NULL,
    user_id integer,
    ingredient_name text NOT NULL,
    quantity text,
    checked boolean DEFAULT false,
    recipe_id integer,
    added_at timestamp without time zone DEFAULT CURRENT_TIMESTAMP
);


ALTER TABLE public.shopping_list OWNER TO postgres;

--
-- Name: shopping_list_id_seq; Type: SEQUENCE; Schema: public; Owner: postgres
--

CREATE SEQUENCE public.shopping_list_id_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER SEQUENCE public.shopping_list_id_seq OWNER TO postgres;

--
-- Name: shopping_list_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: postgres
--

ALTER SEQUENCE public.shopping_list_id_seq OWNED BY public.shopping_list.id;


--
-- Name: steps; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.steps (
    id integer NOT NULL,
    recipe_id integer,
    step_number integer,
    instruction text NOT NULL
);


ALTER TABLE public.steps OWNER TO postgres;

--
-- Name: steps_id_seq; Type: SEQUENCE; Schema: public; Owner: postgres
--

CREATE SEQUENCE public.steps_id_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER SEQUENCE public.steps_id_seq OWNER TO postgres;

--
-- Name: steps_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: postgres
--

ALTER SEQUENCE public.steps_id_seq OWNED BY public.steps.id;


--
-- Name: users; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.users (
    id integer NOT NULL,
    username text NOT NULL,
    phone_number text NOT NULL,
    password text NOT NULL,
    created_at timestamp without time zone DEFAULT CURRENT_TIMESTAMP
);


ALTER TABLE public.users OWNER TO postgres;

--
-- Name: users_id_seq; Type: SEQUENCE; Schema: public; Owner: postgres
--

CREATE SEQUENCE public.users_id_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER SEQUENCE public.users_id_seq OWNER TO postgres;

--
-- Name: users_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: postgres
--

ALTER SEQUENCE public.users_id_seq OWNED BY public.users.id;


--
-- Name: voice_command; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.voice_command (
    id integer NOT NULL,
    user_id integer,
    command text NOT NULL,
    action text,
    recipe_id integer,
    created_at timestamp without time zone DEFAULT CURRENT_TIMESTAMP
);


ALTER TABLE public.voice_command OWNER TO postgres;

--
-- Name: voice_command_id_seq; Type: SEQUENCE; Schema: public; Owner: postgres
--

CREATE SEQUENCE public.voice_command_id_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER SEQUENCE public.voice_command_id_seq OWNER TO postgres;

--
-- Name: voice_command_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: postgres
--

ALTER SEQUENCE public.voice_command_id_seq OWNED BY public.voice_command.id;


--
-- Name: ingredients id; Type: DEFAULT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.ingredients ALTER COLUMN id SET DEFAULT nextval('public.ingredients_id_seq'::regclass);


--
-- Name: recipe_folders id; Type: DEFAULT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.recipe_folders ALTER COLUMN id SET DEFAULT nextval('public.recipe_folders_id_seq'::regclass);


--
-- Name: recipes id; Type: DEFAULT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.recipes ALTER COLUMN id SET DEFAULT nextval('public.recipes_id_seq'::regclass);


--
-- Name: shopping_list id; Type: DEFAULT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.shopping_list ALTER COLUMN id SET DEFAULT nextval('public.shopping_list_id_seq'::regclass);


--
-- Name: steps id; Type: DEFAULT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.steps ALTER COLUMN id SET DEFAULT nextval('public.steps_id_seq'::regclass);


--
-- Name: users id; Type: DEFAULT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.users ALTER COLUMN id SET DEFAULT nextval('public.users_id_seq'::regclass);


--
-- Name: voice_command id; Type: DEFAULT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.voice_command ALTER COLUMN id SET DEFAULT nextval('public.voice_command_id_seq'::regclass);


--
-- Data for Name: favorites; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY public.favorites (user_id, recipe_id, created_at) FROM stdin;
\.


--
-- Data for Name: ingredients; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY public.ingredients (id, recipe_id, name, quantity) FROM stdin;
2463	451	Chicken or pork	
2464	451	Soy sauce	
2465	451	Vinegar	
2466	451	Garlic	
2467	451	Bay leaves	
2468	451	Pepper	
2469	451	Water	
2470	452	Pork, shrimp, or fish	
2471	452	Tomatoes	
2472	452	Onion	
2473	452	Eggplant	
2474	452	Okra	
2475	452	String beans	
2476	452	Water Spinach	
2477	452	Radish	
2478	452	Sinigang/Gabi mix	
2479	452	Water	
2480	453	Oxtail or beef	
2481	453	Peanut butter	
2482	453	Eggplant	
2483	453	String beans	
2484	453	Banana blossom	
2485	453	Garlic	
2486	453	Onion	
2487	453	Water	
2488	454	Pork	
2489	454	Liver	
2490	454	Tomato sauce	
2491	454	Potatoes	
2492	454	Carrots	
2493	454	Garlic	
2494	454	Onion	
2495	454	Soy sauce	
2496	455	Beef or goat meat	
2497	455	Tomato sauce	
2498	455	Potatoes	
2499	455	Carrots	
2500	455	Bell peppers	
2501	455	Garlic	
2502	455	Onion	
2503	455	Liver spread	
2504	456	Chicken	
2505	456	Ginger	
2506	456	Garlic	
2507	456	Onion	
2508	456	Green papaya	
2509	456	Chili leaves	
2510	456	Water	
2511	456	Fish sauce	
2512	457	Pork belly cut into small cubes	
2513	457	Serrano peppers or bird's eye chilies	
2514	457	Coconut milk	
2515	457	Coconut cream	
2516	457	Shrimp paste	
2517	457	Garlic and onion	
2518	457	Ginger	
2519	458	Beef chuck or stew meat	
2520	458	Tomato sauce	
2521	458	Soy sauce	
2522	458	Calamansi juice or lemon juice	
2523	458	Onions and garlic	
2524	458	Potatoes	
2525	458	Carrots	
2526	458	Bell peppers	
2527	458	Beef broth or water	
2528	459	Pork meat and belly pieces	
2529	459	Pig's blood	
2530	459	Vinegar	
2531	459	Long green chilies	
2532	459	Garlic, onion, and ginger	
2533	459	Beef or pork broth	
2534	459	Fish sauce	
2535	460	Pork belly (optional, for flavor)	
2536	460	Shrimp paste	
2537	460	Bitter melon	
2538	460	Eggplant	
2539	460	Okra	
2540	460	String beans	
2541	460	Squash	
2542	460	Tomatoes, garlic, and onion	
2543	460	Water	
2544	461	Shaved ice	
2545	461	Evaporated milk	
2546	461	Sweetened beans, chickpeas, and nata de coco	
2547	461	Leche flan	
2548	461	Ube halaya	
2549	461	Ripe jackfruit	
2550	461	Leche flan and Ube ice cream	
2551	462	Egg yolks	
2552	462	Condensed milk	
2553	462	Evaporated milk	
2554	462	Sugar	
2555	462	Vanilla extract	
2556	463	Coconut milk	
2557	463	Condensed milk	
2558	463	Evaporated milk	
2559	463	Whole corn kernels	
2560	463	Cornstarch	
2561	463	Sugar	
2562	463	Toasted grated coconut or latik	
2563	464	Saba bananas	
2564	464	Sweetened jackfruit strips	
2565	464	Brown sugar	
2566	464	Spring roll wrappers	
2567	464	Cooking oil	
2568	465	Grated cassava	
2569	465	Coconut milk	
2570	465	Condensed milk	
2571	465	Evaporated milk	
2572	465	Sugar	
2573	465	Eggs	
2574	465	Cheddar cheese	
2575	466	Shredded young coconut	
2576	466	Pandan-flavored gelatin cubes	
2577	466	All-purpose cream	
2578	466	Condensed milk	
2579	466	Tapioca pearls	
2580	467	All-purpose flour or rice flour	
2581	467	Baking powder	
2582	467	Sugar	
2583	467	Water or milk	
2584	467	Melted butter	
2585	467	Slices of cheese	
2586	468	Glutinous rice	
2587	468	Cocoa powder or Filipino chocolate tablea	
2588	468	Sugar	
2589	468	Water	
2590	468	Evaporated milk or condensed milk	
2591	468	Fried dried fish	
2592	469	All-purpose flour	
2593	469	Rice flour	
2594	469	Brown sugar	
2595	469	Lye water	
2596	469	Water	
2597	469	Annatto water	
2598	469	Grated fresh coconut	
2599	470	Saba bananas	
2600	470	Brown sugar	
2601	470	Cooking oil	
2602	470	Bamboo skewers	
2603	471	Cooked tapioca pearls	
2604	471	Gelatin cubes	
2605	471	Brown sugar	
2606	471	Water	
2607	471	Vanilla extract or pandan essence	
2608	471	Crushed ice	
2609	472	Fresh young coconut water	
2610	472	Shredded young coconut meat	
2611	472	Sugar or condensed milk	
2612	472	Ice cubes	
2613	473	Fresh calamansi fruits	
2614	473	Water	
2615	473	Sugar or honey	
2616	473	Ice cubes	
2617	474	Cantaloupe melon	
2618	474	Water	
2619	474	Sugar	
2620	474	Evaporated milk	
2621	474	Ice cubes	
2622	475	Ground Barako coffee beans	
2623	475	Water	
2624	475	Brown sugar or honey	
2625	476	Aged kimchi	
2626	476	Pork belly or pork shoulder	
2627	476	Tofu	
2628	476	Green onions	
2629	476	Garlic	
2630	476	Gochugaru	
2631	476	Gochujang	
2632	476	Water or kelp broth	
2633	477	Thinly sliced beef (ribeye or sirloin)	
2634	477	Soy sauce	
2635	477	Brown sugar	
2636	477	Grated Asian pear	
2637	477	Minced garlic and ginger	
2638	477	Sesame oil	
2639	477	Green onions	
2640	477	Toasted sesame seeds	
2641	478	Cooked short-grain rice	
2642	478	Ground beef or sliced beef	
2643	478	Spinach, bean sprouts, carrots, shiitake mushrooms	
2644	478	Eggs	
2645	478	Soy sauce and garlic	
2646	478	Gochujang	
2647	478	Sesame oil and sesame seeds	
2648	479	Korean rice cakes (tteok)	
2649	479	Korean fish cakes (eomuk)	
2650	479	Gochujang	
2651	479	Gochugaru	
2652	479	Sugar or corn syrup	
2653	479	Soy sauce and minced garlic	
2654	479	Anchovy and kelp broth	
2655	479	Green onions	
2656	480	Whole young chicken	
2657	480	Glutinous rice (soaked)	
2658	480	Fresh ginseng root	
2659	480	Dried jujubes (red dates)	
2660	480	Garlic cloves	
2661	480	Ginger slices	
2662	480	Water	
2663	480	Green onions, salt, and black pepper	
2664	481	Jajangmyeon noodles	
2665	481	Korean black bean paste (chunjang)	
2666	481	Pork belly or pork shoulder	
2667	481	Zucchini, cabbage, and onions	
2668	481	Sugar and soy sauce	
2669	481	Potato starch slurry	
2670	481	Cooking oil and water	
2671	482	Beef short ribs (galbi)	
2672	482	Korean radish (mu)	
2673	482	Garlic cloves and onion	
2674	482	Soy sauce	
2675	482	Salt and black pepper	
2676	482	Dangmyeon	
2677	482	Green onions	
2678	482	Water	
2679	483	Soft/silken tofu (sundubu)	
2680	483	Mixed seafood or pork	
2681	483	Gochugaru	
2682	483	Garlic and green onions	
2683	483	Sesame oil	
2684	483	Anchovy broth or water	
2685	483	Fish sauce or salt	
2686	483	Raw egg	
2687	484	Dangmyeon (sweet potato starch glass noodles)	
2688	484	Beef strips	
2689	484	Spinach, carrots, onions, shiitake mushrooms	
2690	484	Soy sauce	
2691	484	Sugar	
2692	484	Garlic	
2693	484	Sesame oil and toasted sesame seeds	
2694	485	Boneless chicken thighs	
2695	485	Cabbage	
2696	485	Korean sweet potato	
2697	485	Rice cakes (tteok)	
2698	485	Gochujang, gochugaru, soy sauce, sugar	
2699	485	Minced garlic and ginger	
2700	485	Green onions and perilla leaves	
2701	486	Shaved ice	
2702	486	Sweetened red bean paste (pat)	
2703	486	Tteok (mini rice cake cubes)	
2704	486	Condensed milk	
2705	486	Misugaru	
2706	487	Yeast dough (wheat flour, water, milk, yeast, sugar)	
2707	487	Dark brown sugar	
2708	487	Cinnamon powder	
2709	487	Chopped walnuts or sunflower seeds	
2710	487	Cooking oil	
2711	488	Wheat flour	
2712	488	Sesame oil	
2713	488	Honey or rice syrup	
2714	488	Ginger juice or minced ginger	
2715	488	Water	
2716	488	Cooking oil for frying	
2717	489	Glutinous rice flour	
2718	489	Hot water	
2719	489	Salt	
2720	489	Sweet red bean paste	
2721	489	Black sesame powder, roasted soybean powder, mugwort powder	
2722	490	Pastry batter (flour, baking powder, sugar, milk, water, egg)	
2723	490	Sweetened red bean paste	
2724	490	Melted butter or oil	
2725	491	Rice flour (non-glutinous)	
2726	491	Hot water	
2727	491	Toasted sesame seeds with honey, sweet red bean, or chestnuts	
2728	491	Fresh pine needles	
2729	491	Sesame oil	
2730	492	Glutinous rice flour	
2731	492	Hot water	
2732	492	Edible flowers (azaleas, chrysanthemums, or rose petals)	
2733	492	Honey or sugar syrup	
2734	492	Cooking oil	
2735	493	Traditional Sikhye (sweet rice beverage)	
2736	493	Pine nuts	
2737	494	Glutinous rice flour	
2738	494	Sugar and salt	
2739	494	Water	
2740	494	Sweetened red bean paste	
2741	494	Cornstarch or potato starch	
2742	495	Korean sweet potatoes	
2743	495	Cooking oil for deep frying	
2744	495	Sugar	
2745	495	Water	
2746	495	Black sesame seeds	
2889	520	Milk	
2747	496	Malted barley powder (yeotgireum)	
2748	496	Water	
2749	496	Cooked white rice	
2750	496	Sugar	
2751	496	Pine nuts	
2752	497	Cinnamon sticks	
2753	497	Fresh ginger slices	
2754	497	Water	
2755	497	Brown sugar or white sugar	
2756	497	Dried persimmons (gotgam)	
2757	497	Pine nuts	
2758	498	Yuja cheong (Korean yuzu marmalade/preserve)	
2759	498	Hot water	
2760	499	Roasted barley grains	
2761	499	Water	
2762	500	Misugaru powder (roasted multi-grain powder)	
2763	500	Milk or water	
2764	500	Honey or sugar	
2765	500	Ice cubes	
2766	501	Chicken breasts or thighs	
2767	501	Panko	
2768	501	Flour and beaten eggs	
2769	501	Japanese curry roux blocks	
2770	501	Potatoes, carrots, and onions	
2771	501	Cooking oil	
2772	501	Water or dashi broth	
2773	501	Steamed white rice	
2774	502	Ramen noodles	
2775	502	Pork bones	
2776	502	Chashu (braised pork belly slices)	
2777	502	Ajitsuke Tamago (marinated soft-boiled egg)	
2778	502	Green onions	
2779	502	Nori (dried seaweed sheets)	
2780	502	Menma (seasoned bamboo shoots)	
2781	502	Soy sauce and mirin	
2782	503	Thinly sliced beef (short plate or ribeye)	
2783	503	Onions	
2784	503	Dashi broth	
2785	503	Soy sauce	
2786	503	Mirin	
2787	503	Sugar	
2788	503	Steamed white rice	
2789	503	Pickled red ginger (beni shoga)	
2790	504	Chicken thighs	
2791	504	Soy sauce	
2792	504	Mirin	
2793	504	Sake	
2794	504	Sugar	
2795	504	Grated ginger	
2796	504	Cooking oil	
2797	505	Large shrimp	
2798	505	Vegetables (sweet potato, eggplant, pumpkin, shiitake)	
2799	505	Tempura flour	
2800	505	Ice-cold water	
2801	505	Egg yolk	
2802	505	Oil for deep frying	
2803	505	Tentsuyu (dipping sauce)	
2804	506	Thinly sliced beef	
2805	506	Grilled tofu (yaki-dofu)	
2806	506	Shiitake and enoki mushrooms	
2807	506	Nagaogi (Japanese long green onion)	
2808	506	Shirataki noodles	
2809	506	Soy sauce, mirin, sake, sugar	
2810	506	Fresh raw eggs	
2811	507	Tonkatsu (crispy deep-fried pork cutlet)	
2812	507	Onion	
2813	507	Egg	
2814	507	Dashi broth	
2815	507	Soy sauce and mirin	
2816	507	Sugar	
2817	507	Steamed white rice	
2818	508	Chicken thigh	
2819	508	Onion	
2820	508	Eggs	
2821	508	Dashi broth	
2822	508	Soy sauce	
2823	508	Mirin	
2824	508	Sugar	
2825	508	Steamed white rice	
2826	509	Yakisoba noodles	
2827	509	Pork belly slices	
2828	509	Cabbage	
2829	509	Carrots and onions	
2830	509	Yakisoba sauce	
2831	509	Cooking oil	
2832	509	Aonori and pickled red ginger	
2833	510	Mackerel fillets (saba)	
2834	510	Coarse sea salt	
2835	510	Daikon radish	
2836	510	Soy sauce	
2837	510	Cooking oil	
2838	511	Glutinous rice flour (shiratamako or mochiko)	
2839	511	Matcha powder	
2840	511	Sugar	
2841	511	Water	
2842	511	Sweet red bean paste (anko)	
2843	511	Cornstarch	
2844	512	Eggs	
2845	512	Sugar	
2846	512	Honey	
2847	512	All-purpose flour	
2848	512	Baking powder	
2849	512	Water or milk	
2850	512	Sweet red bean paste (anko)	
2851	512	Vegetable oil	
2852	513	Heavy cream	
2853	513	Whole milk	
2854	513	Sugar	
2855	513	High-quality matcha powder	
2856	513	Pinch of salt	
2857	514	Eggs	
2858	514	Bread flour	
2859	514	Sugar	
2860	514	Honey	
2861	514	Warm water	
2862	515	Joshinko (rice flour) and Shiratamako (glutinous rice flour)	
2863	515	Warm water	
2864	515	Soy sauce, mirin, sugar	
2865	515	Potato starch	
2866	515	Bamboo skewers	
2867	516	Sponge cake (flour, eggs, sugar, melted butter)	
2868	516	Heavy whipping cream	
2869	516	Powdered sugar	
2870	516	Fresh strawberries	
2871	516	Simple sugar syrup	
2872	517	Cake flour	
2873	517	Baking powder	
2874	517	Sugar	
2875	517	Egg and milk	
2876	517	Sweet vanilla custard or sweet red bean paste	
2877	518	Strong brewed black coffee	
2878	518	Gelatin powder	
2879	518	Sugar	
2880	518	Water	
2881	518	Heavy cream or evaporated milk	
2882	519	Agar-agar powder (kanten)	
2883	519	Water	
2884	519	Sweet red bean paste (anko)	
2885	519	Mochi pieces or dango	
2886	519	Canned mixed fruits	
2887	519	Kuromitsu (Japanese black sugar syrup)	
2888	520	Eggs	
2890	520	Sugar	
2891	520	Vanilla extract	
2892	520	Water	
2893	521	Matcha powder	
2894	521	Hot water	
2895	521	Whole milk (or oat milk)	
2896	521	Honey or sugar	
2897	522	Genmaicha loose tea leaves	
2898	522	Hot water	
2899	523	Hojicha tea leaves (roasted green tea)	
2900	523	Boiling water	
2901	524	Store-bought Ramune soda bottle (original lemon-lime flavor)	
2902	525	Roasted barley tea bags (mugicha pack)	
2903	525	Water	
2904	525	Ice cubes	
2905	526	Chicken breast or thighs	
2906	526	Roasted peanuts	
2907	526	Dried red chili peppers	
2908	526	Sichuan peppercorns	
2909	526	Soy sauce, Chinese black vinegar, sugar	
2910	526	Garlic and ginger	
2911	526	Scallions	
2912	526	Cornstarch	
2913	527	Soft or silken tofu	
2914	527	Minced pork or beef	
2915	527	Pixian Doubanjiang (chili bean paste)	
2916	527	Gochugaru or Chinese chili flakes	
2917	527	Ground Sichuan peppercorn powder	
2918	527	Garlic and ginger	
2919	527	Chicken broth or water	
2920	527	Cornstarch slurry	
2921	528	Pork shoulder or tenderloin	
2922	528	Egg yolk and cornstarch	
2923	528	Bell peppers and onions	
2924	528	Pineapple chunks	
2925	528	Ketchup, rice vinegar, sugar	
2926	528	Cooking oil for deep-frying	
2927	529	Whole duck	
2928	529	Maltose syrup or honey mixed with water	
2929	529	Five-spice powder	
2930	529	Chinese thin pancakes	
2931	529	Sweet bean sauce (Tianmianjiang) or Hoisin sauce	
2932	529	Cucumber and scallions	
2933	530	Flank steak	
2934	530	Broccoli florets	
2935	530	Oyster sauce	
2936	530	Soy sauce	
2937	530	Minced garlic and ginger	
2938	530	Shaoxing rice wine	
2939	530	Cornstarch and baking soda	
2940	531	Thin egg noodles	
2941	531	Wonton wrappers	
2942	531	Ground pork and minced shrimp	
2943	531	Sesame oil, white pepper, soy sauce	
2944	531	Chicken or pork bone broth	
2945	531	Leafy greens (like bok choy)	
2946	532	Leftover day-old cooked jasmine rice	
2947	532	Chinese barbecue pork (Char Siu, diced)	
2948	532	Small shrimp	
2949	532	Eggs	
2950	532	Green peas and diced carrots	
2951	532	Scallions	
2952	532	Soy sauce or salt and white pepper	
2953	533	Pork belly chunk	
2954	533	Sweet bean paste (Tianmianjiang)	
2955	533	Chili bean paste (Doubanjiang)	
2956	533	Chinese leeks or green bell peppers	
2957	533	Ginger and garlic	
2958	533	Shaoxing rice wine	
2959	534	Whole fresh white fish (such as sea bass or tilapia)	
2960	534	Fresh ginger	
2961	534	Scallions	
2962	534	Light soy sauce, sugar, water	
2963	534	Cooking oil	
2964	535	Pork belly	
2965	535	Rock sugar	
2966	535	Light soy sauce and dark soy sauce	
2967	535	Shaoxing rice wine	
2968	535	Star anise and cinnamon stick	
2969	535	Ginger slices	
2970	536	Puff pastry or shortcrust pastry dough	
2971	536	Egg yolks	
2972	536	Evaporated milk or heavy cream	
2973	536	Sugar	
2974	536	Water	
2975	536	Vanilla extract	
2976	537	Glutinous rice flour	
2977	537	Brown sugar dissolved in hot water	
2978	537	Sweet red bean paste (anko)	
2979	537	White sesame seeds	
2980	537	Oil for deep frying	
2981	538	Ripe sweet mangoes	
2982	538	Sago pearls (tapioca pearls, cooked)	
2983	538	Pomelo or grapefruit segments	
2984	538	Coconut milk	
2985	538	Evaporated milk or condensed milk	
2986	539	Dried red adzuki beans	
2987	539	Rock sugar	
2988	539	Water	
2989	539	Dried tangerine peel (optional)	
2990	540	Glutinous rice flour and warm water	
2991	540	Roasted black sesame powder	
2992	540	Sugar and melted lard or butter	
2993	540	Water, rock sugar, and sliced ginger	
2994	541	Almond extract or apricot kernel milk	
2995	541	Agar-agar powder or gelatin	
2996	541	Milk	
2997	541	Sugar and water	
2998	541	Canned fruit cocktail or mandarin oranges	
2999	542	All-purpose flour	
3000	542	Rice flour	
3001	542	Baking powder	
3002	542	Brown sugar	
3003	542	Water	
3004	543	Milk	
3005	543	Cornstarch and sugar	
3006	543	Flour, baking powder, water, and oil	
3007	544	Marshmallows	
3008	544	Butter	
3009	544	Milk powder	
3010	544	Hard milk biscuits	
3011	544	Dried cranberries and chopped nuts	
3012	545	Dried osmanthus flowers	
3013	545	Rock sugar	
3014	545	Agar-agar powder or gelatin sheets	
3015	545	Water	
3016	546	Black tea leaves (Assam or Ceylon)	
3017	546	Whole milk or non-dairy creamer	
3018	546	Cooked black tapioca pearls (boba)	
3019	546	Brown sugar syrup or honey	
3020	546	Ice cubes	
3021	547	Dried Chinese chrysanthemum flowers	
3022	547	Rock sugar	
3023	547	Hot water	
3024	548	Smoked plums (Wumei)	
3025	548	Dried hawthorn berries (Shanzha)	
3026	548	Licorice root (Gancao)	
3027	548	Rock sugar	
3028	548	Water	
3029	549	Brewed green tea or Oolong tea (chilled)	
3030	549	Cream cheese	
3031	549	Heavy whipping cream	
3032	549	Milk	
3033	549	Sugar and sea salt	
3034	550	Yellow soybeans	
3035	550	Water	
3036	550	Sugar	
3037	551	Leftover cooked jasmine rice	
3038	551	Sweet soy sauce (Kecap Manis)	
3039	551	Chicken pieces and small shrimp	
3040	551	Eggs	
3041	551	Shallots and garlic	
3042	551	Chili paste (Sambal)	
3043	551	Cooking oil	
3044	551	Fried shallots	
3045	552	Beef chuck or brisket	
3046	552	Coconut milk and coconut cream	
3047	552	Lemongrass, kaffir lime leaves, turmeric leaves	
3048	552	Toasted grated coconut (Kerisik)	
3049	552	Spice paste (shallots, garlic, ginger, galangal, chili, coriander seeds)	
3050	553	Boneless chicken thighs	
3051	553	Coriander powder, turmeric powder, sweet soy sauce	
3052	553	Raw peanuts	
3053	553	Garlic, shallots, candlenuts	
3054	553	Brown sugar and salt	
3055	553	Bamboo skewers	
3056	554	Cabbage, spinach, bean sprouts	
3057	554	Long beans	
3058	554	Fried tofu and tempeh cubes	
3059	554	Hard-boiled eggs	
3060	554	Boiled potatoes	
3061	554	Indonesian peanut dressing	
3062	554	Prawn crackers (krupuk)	
3063	555	Whole chicken	
3064	555	Fresh galangal (laos, finely grated)	
3065	555	Lemongrass and bay leaves (daun salam)	
3066	555	Spice paste (shallots, garlic, turmeric, ginger, coriander seeds)	
3067	555	Water	
3068	555	Cooking oil for deep frying	
3069	556	Indonesian beef meatballs (bakso cubes/spheres)	
3070	556	Yellow egg noodles or rice vermicelli	
3071	556	Beef bone broth	
3072	556	Garlic	
3073	556	Celery and scallions	
3074	556	Sweet soy sauce and sambal	
3075	557	Chicken pieces	
3076	557	Spice paste (shallots, garlic, turmeric, ginger, candlenuts)	
3077	557	Lemongrass, kaffir lime leaves, bay leaves	
3078	557	Glass noodles (vermicelli, soaked)	
3079	557	Bean sprouts and hard-boiled eggs	
3080	557	Water	
3081	558	Fresh white fish fillets (tilapia or snapper)	
3082	558	Spice paste (shallots, garlic, red chilies, turmeric, ginger, candlenuts)	
3083	558	Lemongrass and tomato slices	
3084	558	Fresh lemon basil leaves (kemangi)	
3085	558	Banana leaves	
3086	558	Toothpicks	
3087	559	Chicken breast strips or fish balls	
3088	559	Cauliflower florets, carrots, bok choy	
3089	559	Cabbage and mushrooms	
3090	559	Garlic	
3091	559	Oyster sauce, soy sauce, fish sauce	
3092	559	Chicken broth	
3093	559	Cornstarch slurry	
3094	560	Beef brisket	
3095	560	Kluwek nuts	
3096	560	Spice paste (shallots, garlic, galangal, coriander, turmeric)	
3097	560	Lemongrass and kaffir lime leaves	
3098	560	Water	
3099	560	Salt and sugar	
3100	561	Ripe avocado	
3101	561	Jackfruit strips	
3102	561	Young coconut meat	
3103	561	Shaved ice	
3104	561	Condensed milk	
3105	561	Simple sugar syrup	
3106	562	Pancake batter (flour, sugar, eggs, milk, baking soda)	
3107	562	Butter	
3108	562	Chocolate sprinkles (meisjes)	
3109	562	Grated cheddar cheese	
3110	562	Crushed roasted peanuts	
3111	562	Condensed milk	
3112	563	Glutinous rice flour	
3113	563	Pandan juice or extract	
3114	563	Palm sugar (Gula Melaka, finely chopped)	
3115	563	Grated coconut	
3116	563	Warm water	
3117	564	Rice flour	
3118	564	Coconut milk	
3119	564	Pandan leaves	
3120	564	Salt	
3121	564	Palm sugar and water	
3122	565	Ripe saba or plantain bananas	
3123	565	Rice flour and all-purpose flour	
3124	565	Baking powder, sugar, salt	
3125	565	Ice-cold water	
3126	565	Oil for deep frying	
3127	566	Crepe batter (flour, egg, coconut milk, pandan extract)	
3128	566	Grated fresh coconut flesh	
3129	566	Palm sugar	
3130	566	Water and pandan leaves	
3131	567	Ripe bananas	
3132	567	Coconut milk	
3133	567	Palm sugar	
3134	567	Pandan leaves	
3135	567	Water and salt	
3136	568	Butter	
3137	568	Egg yolks	
3138	568	Powdered sugar	
3139	568	Flour	
3140	568	Spekoek spice mix (cinnamon, clove, nutmeg, cardamom)	
3141	569	Cassava root	
3142	569	Sugar or palm sugar	
3143	569	Grated fresh coconut	
3144	569	Food coloring (optional)	
3145	570	Rice flour	
3146	570	Coconut milk	
3147	570	Sugar and salt	
3148	570	Ripe bananas	
3149	570	Banana leaves	
3150	571	Cendol (green rice flour jelly droplets)	
3151	571	Coconut milk	
3152	571	Palm sugar syrup	
3153	571	Crushed ice	
3154	572	Fine ground coffee beans (Robusta or Arabica)	
3155	572	Boiling water	
3156	572	Sugar	
3157	573	Fresh ginger root	
3158	573	Lemongrass	
3159	573	Palm sugar or brown sugar	
3160	573	Water	
3161	574	Fresh young coconut	
3162	574	Simple syrup or liquid sugar	
3163	574	Ice cubes	
3164	575	Ripe avocado flesh	
3165	575	Milk or water	
3166	575	Sugar syrup	
3167	575	Chocolate condensed milk	
3168	575	Ice cubes	
3169	576	Long-grain parboiled rice	
3170	576	Tomatoes, red bell peppers, scotch bonnet peppers	
3171	576	Tomato paste	
3172	576	Onions	
3173	576	Chicken or beef stock	
3174	576	Curry powder and dried thyme	
3175	576	Bay leaves	
3176	576	Vegetable oil	
3177	577	Ground egusi (melon seeds)	
3178	577	Palm oil	
3179	577	Assorted meats (beef, shaki, cow skin) and dried fish	
3180	577	Ground crayfish	
3181	577	Fresh spinach or bitter leaf	
3182	577	Blended pepper mix (onions and scotch bonnets)	
3183	577	White yam	
3184	578	Flank steak or sirloin	
3185	578	Yaji spice (ground peanuts, chili powder, ginger, garlic, bouillon)	
3186	578	Vegetable oil	
3187	578	Red onions and tomatoes	
3188	578	Bamboo skewers	
3189	579	Ground ogbono seeds	
3190	579	Palm oil	
3191	579	Assorted meats and stockfish	
3192	579	Ground crayfish	
3193	579	Leafy vegetables (ugwu or spinach)	
3194	579	Meat stock or water	
3195	579	White yam	
3196	580	Fresh spinach or tatase leaves	
3197	580	Coarsely blended bell peppers, scotch bonnets, and onions	
3198	580	Palm oil	
3199	580	Iru (fermented locust beans)	
3200	580	Smoked fish, stockfish, and diced beef	
3201	580	Ground crayfish	
3202	581	Goat meat or catfish	
3203	581	African pepper soup spice mix (ehu, uziza, and uda seeds)	
3204	581	Scent leaves or utazi leaves	
3205	581	Scotch bonnet peppers	
3206	581	Onions	
3207	581	Water	
3208	582	Elubo (dark yam flour)	
3209	582	Ewedu leaves (jute leaves, blended)	
3210	582	Gbegiri base (peeled brown beans, boiled and pureed)	
3211	582	Palm oil and iru	
3212	582	Obe ata (fried pepper sauce with assorted meats)	
3213	582	Boiling water	
3214	583	Short-grain soft rice	
3215	583	Ripe pumpkin	
3216	583	Meat chunks and smoked fish	
3217	583	Ground roasted peanuts	
3218	583	Blended tomatoes, peppers, and onions	
3219	583	Scent leaves or spinach	
3220	583	Water	
3221	584	Long-grain parboiled rice	
3222	584	Chicken stock	
3223	584	Curry powder and thyme	
3224	584	Cooked beef liver	
3225	584	Carrots, green beans, sweet corn, onions	
3226	584	Vegetable oil	
3227	585	Goat meat (bite-sized pieces, with skin on)	
3228	585	Scotch bonnet peppers (atarodo, coarsely chopped)	
3229	585	Onions	
3230	585	Vegetable oil	
3231	585	Black pepper and salt	
3232	586	All-purpose flour	
3233	586	Granulated sugar	
3234	586	Active dry yeast	
3235	586	Warm water	
3236	586	Nutmeg and salt	
3237	586	Vegetable oil	
3238	587	All-purpose flour	
3239	587	Sugar	
3240	587	Margarine or butter	
3241	587	Milk	
3242	587	Egg	
3243	587	Baking powder and nutmeg	
3244	588	Very overripe black-skinned plantains	
3245	588	All-purpose flour	
3246	588	Active dry yeast	
3247	588	Warm water	
3248	588	Chili flakes and salt	
3249	588	Cooking oil	
3250	589	Fresh coconut	
3251	589	Granulated sugar	
3252	589	Water	
3253	590	Unsweetened desiccated coconut flakes	
3254	590	Egg yolks	
3255	590	Powdered sugar	
3256	590	Self-rising flour	
3257	591	All-purpose flour and butter	
3258	591	Cold water	
3259	591	Ground beef	
3260	591	Carrots and potatoes	
3261	591	Seasoning and sugar	
3262	591	Egg	
3263	592	Raw roasted peanuts (groundnuts)	
3264	592	Chili powder (cayenne)	
3265	592	Ground ginger	
3266	592	Groundnut oil	
3267	593	Flour	
3268	593	Yeast	
3269	593	Warm water	
3270	593	Sugar or honey	
3271	593	Salt	
3272	594	Peeled brown or black-eyed beans	
3273	594	Granulated sugar	
3274	594	Water	
3275	594	Salt	
3276	594	Vegetable oil	
3277	595	Flour	
3278	595	Sugar	
3279	595	Milk and egg	
3280	595	Baking powder	
3281	595	Powdered sugar	
3282	596	Dried hibiscus calyces (zobo leaves)	
3283	596	Fresh ginger root	
3284	596	Pineapples	
3285	596	Cloves (konafuru)	
3286	596	Water	
3287	596	Sugar or honey	
3288	597	Dry tiger nuts (aya)	
3289	597	Dried dates (debino, pitted)	
3290	597	Fresh coconut meat	
3291	597	Ginger root	
3292	597	Cold water	
3293	598	Fanta Orange soda	
3294	598	Sprite or 7-Up soda	
3295	598	Blackcurrant cordial (Ribena) or Grenadine syrup	
3296	598	Angostura bitters	
3297	598	Cucumber, orange, and lemon slices	
3298	598	Ice cubes	
3299	599	Millet grains	
3300	599	Sweet potato chunks	
3301	599	Ginger root and cloves	
3302	599	Water	
3303	599	Sugar	
3304	600	Freshly tapped Palm Wine (store-bought or sourced fresh)	
3305	601	Minced beef or lamb	
3306	601	Onions	
3307	601	Slice of white bread (soaked in milk)	
3308	601	Curry powder and turmeric	
3309	601	Apricot jam or chutney	
3310	601	Sultanas or raisins	
3311	601	Eggs and milk	
3312	601	Bay leaves	
3313	602	Whole loaf of white bread	
3314	602	Mutton, chicken, or beef	
3315	602	Potatoes	
3316	602	Curry powder and garam masala	
3317	602	Onions, ginger, garlic	
3318	602	Chopped tomatoes	
3319	602	Curry leaves	
3320	603	Coarsely minced beef and pork	
3321	603	Pork fat	
3322	603	Toasted coriander seeds	
3323	603	Black pepper, nutmeg, cloves	
3324	603	Brown vinegar	
3325	603	Sausage casings	
3326	604	Beef oxtail or lamb shanks	
3327	604	Onions	
3328	604	Potatoes, carrots, mushrooms	
3329	604	Red wine and beef stock	
3330	604	Garlic and fresh herbs (thyme, rosemary)	
3331	604	Cooking oil	
3332	605	Maize meal	
3333	605	Grated carrots and sliced cabbage	
3334	605	Bell peppers and onions	
3335	605	Baked beans (canned)	
3336	605	Hot curry powder	
3337	605	Garlic, ginger, chilies	
3338	606	Whole snoek fish	
3339	606	Apricot jam	
3340	606	Butter	
3341	606	Minced garlic	
3342	606	Lemon juice	
3343	606	Salt and pepper	
3344	607	Mutton or lamb pieces	
3345	607	Soft ripe tomatoes or canned whole tomatoes	
3346	607	Onions	
3347	607	Potatoes	
3348	607	Ginger and garlic	
3349	607	Chili, cinnamon stick, cardamom pods	
3350	607	Sugar	
3351	608	Bread dough (flour, yeast, sugar, water, salt)	
3352	608	Minced beef	
3353	608	Onions and garlic	
3354	608	Mild curry powder	
3355	608	Diced carrots and peas	
3356	608	Oil for deep-frying	
3357	609	Lamb or beef cubes	
3358	609	Onions	
3359	609	Tamarind paste	
3360	609	Ground coriander and allspice	
3361	609	Bay leaves	
3362	609	Sugar, salt, pepper	
3363	610	White long-grain rice	
3364	610	Turmeric powder	
3365	610	Cinnamon stick	
3366	610	Butter	
3367	610	Sugar	
3368	610	Raisins or sultanas	
3369	610	Water	
3370	611	Flour, sugar, egg	
3371	611	Apricot jam	
3372	611	Milk and butter	
3373	611	Vinegar and baking soda	
3374	611	Sauce (heavy cream, butter, sugar, vanilla, water)	
3375	612	Puff pastry or shortcrust pastry dough	
3376	612	Milk	
3377	612	Eggs	
3378	612	Sugar	
3379	612	Cornstarch and flour	
3380	612	Butter and vanilla extract	
3381	612	Cinnamon powder	
3382	613	Flour, baking powder, salt	
3383	613	Butter and milk	
3384	613	Syrup (sugar, water, lemon juice, fresh ginger)	
3385	613	Cooking oil for deep-frying	
3386	614	Tennis biscuits (or any flat coconut biscuits)	
3387	614	Caramel treat (dulce de leche)	
3388	614	Heavy whipping cream	
3389	614	Peppermint Crisp chocolate bars (grated)	
3390	615	Puff pastry or shortcrust pastry dough	
3391	615	Smooth apricot jam	
3392	615	Egg whites	
3393	615	Castor sugar	
3394	615	Desiccated coconut flakes	
3395	616	Chopped dried dates	
3396	616	Baking soda and boiling water	
3397	616	Flour, sugar, butter	
3398	616	Chopped pecan nuts	
3399	616	Syrup (sugar, water, butter, vanilla, brandy)	
3400	617	Flour, sugar, baking powder	
3401	617	Butter and lard	
3402	617	Sweet red wine or port	
3403	617	Ground cinnamon, ginger, cloves	
3404	617	Egg	
3405	618	Rolled oats	
3406	618	Desiccated coconut flakes	
3407	618	Flour and sugar	
3408	618	Butter	
3409	618	Golden syrup	
3410	618	Baking soda	
3411	619	Flour, sugar, salt	
3412	619	Active dry yeast (or grape must ferment)	
3413	619	Whole aniseeds	
3414	619	Melted butter and warm milk	
3415	620	Strong brewed Rooibos tea	
3416	620	Honey or sugar	
3417	620	Gelatin sheets or powder	
3418	620	Fresh lemon juice	
3419	621	Rooibos tea bags or loose leaves	
3420	621	Boiling water	
3421	621	Milk and honey	
3422	622	Premium vanilla ice cream	
3423	622	Heavy cream	
3424	622	Amarula cream liqueur or Kahlúa	
3425	622	Cocoa powder or grated chocolate	
3426	623	Smooth thin pap (maize meal porridge, cooled)	
3427	623	Wheat flour	
3428	623	Sugar	
3429	623	Water	
3430	624	Ginger beer	
3431	624	Cream soda (South African green variety preferred)	
3432	624	Angostura bitters	
3433	624	Ice cubes	
3434	625	Sorghum meal/powder	
3435	625	Water	
3436	625	Sorghum malt (crushed)	
3437	626	Brown lentils	
3438	626	White rice	
3439	626	Macaroni or spaghetti pieces	
3440	626	Chickpeas	
3441	626	Tomato paste and crushed tomatoes	
3442	626	Garlic, vinegar, cumin	
3443	626	Onions	
3444	626	Cooking oil	
3445	627	Fresh or frozen molokhia leaves	
3446	627	Whole chicken	
3447	627	Coriander powder	
3448	627	Garlic	
3449	627	Ghee or butter	
3450	627	Chicken broth	
3451	627	Cardamom, mastic, bay leaves	
3452	628	Whole pigeons (cleaned)	
3453	628	Freekeh (cracked green wheat) or Egyptian short-grain rice	
3454	628	Onions	
3455	628	Cinnamon, nutmeg, allspice	
3456	628	Ghee or butter	
3457	628	Chicken broth or water	
3458	628	Salt and black pepper	
3459	629	Beef chunks	
3460	629	Egyptian short-grain rice	
3461	629	Baladi flatbread	
3462	629	Garlic	
3463	629	White vinegar	
3464	629	Tomato sauce	
3465	629	Ghee or butter	
3466	629	Beef broth	
3467	630	Zucchini, eggplants, bell peppers	
3468	630	Egyptian short-grain rice	
3469	630	Onions	
3470	630	Tomato puree	
3471	630	Fresh parsley, dill, coriander	
3472	630	Cumin and coriander powder	
3473	630	Chicken or beef broth	
3474	631	Egyptian Baladi bread or pita pockets	
3475	631	Minced beef (with a good fat ratio)	
3476	631	Onions and bell peppers	
3477	631	Scotch bonnet or chili pepper	
3478	631	Allspice, cinnamon, cumin	
3479	631	Melted ghee or vegetable oil	
3480	632	Penne pasta	
3481	632	Minced beef	
3482	632	Onions	
3483	632	Tomato paste	
3484	632	Flour, butter, milk	
3485	632	Allspice and nutmeg	
3486	632	Egg	
3487	633	Fresh or frozen small okra (bamia)	
3488	633	Lamb chunks	
3489	633	Tomato puree and tomato paste	
3490	633	Onions	
3491	633	Garlic	
3492	633	Ground coriander	
3493	633	Lemon juice	
3494	633	Ghee or oil	
3495	634	White fish fillets (sea bass or tilapia)	
3496	634	White rice	
3497	634	Onions	
3498	634	Cumin and coriander powder	
3499	634	Garlic	
3500	634	Fish stock or water	
3501	634	Cooking oil	
3502	635	Beef liver	
3503	635	Garlic	
3504	635	Green bell peppers and hot chili peppers	
3505	635	Cumin and coriander powder	
3506	635	White vinegar and fresh lime juice	
3507	635	Cooking oil	
3508	636	Coarse semolina flour	
3509	636	Ghee or butter	
3510	636	Plain yogurt	
3511	636	Sugar	
3512	636	Unsweetened desiccated coconut flakes	
3513	636	Whole blanched almonds	
3514	636	Sharbat syrup (sugar, water, lemon juice, rose water)	
3515	637	Puff pastry sheets	
3516	637	Whole milk and heavy cream	
3517	637	Sugar	
3518	637	Mixed nuts (pistachios, almonds, hazelnuts)	
3519	637	Raisins and coconut flakes	
3520	637	Vanilla extract	
3521	638	Kataifi pastry dough (shredded kunafa dough)	
3522	638	Ghee or butter	
3523	638	Ashta (thick clotted cream) or sweet cheese	
3524	638	Ground pistachios	
3525	638	Sugar syrup (infused with rose water)	
3526	639	Flour, semolina, sugar	
3527	639	Yeast and baking powder	
3528	639	Warm water	
3529	639	Filling (chopped walnuts, sugar, cinnamon OR whipped cream)	
3530	639	Simple syrup	
3531	640	Egyptian short-grain rice	
3532	640	Whole milk	
3533	640	Sugar	
3534	640	Cornstarch	
3535	640	Ground mastic beads and rose water	
3536	640	Chopped nuts	
3537	641	All-purpose flour	
3538	641	Cornstarch	
3539	641	Yeast and sugar	
3540	641	Warm water	
3541	641	Vegetable oil for deep-frying	
3542	641	Thick simple syrup or powdered sugar	
3543	642	All-purpose flour	
3544	642	Warm water and salt	
3545	642	Ghee or melted butter	
3546	642	Black honey (molasses) or white honey	
3547	642	Eshta (clotted cream)	
3548	643	Ghee (clarified butter, chilled and firm)	
3549	643	Powdered sugar	
3550	643	All-purpose flour	
3551	643	Whole pistachios or whole cloves	
3552	644	All-purpose flour	
3553	644	Ghee	
3554	644	Sesame seeds	
3555	644	Yeast and warm water	
3556	644	Kahk spice mix (cinnamon, cloves, mahlab)	
3557	644	Date paste (agwa) or chopped nuts	
3558	644	Powdered sugar	
3559	645	Whole milk	
3560	645	Sugar	
3561	645	Cornstarch	
3562	645	Orange blossom water or rose water	
3563	645	Crushed pistachios and cinnamon	
3564	646	Dried hibiscus flowers (karkadeh leaves)	
3565	646	Water	
3566	646	Sugar	
3567	647	Loose black tea leaves (or tea bags)	
3568	647	Fresh spearmint sprigs	
3569	647	Boiling water	
3570	647	Sugar	
3571	648	Whole milk	
3572	648	Sahlab powder mix (or cornstarch mixed with vanilla and milk powder)	
3573	648	Sugar	
3574	648	Shredded coconut and raisins	
3575	648	Crushed pistachios or walnuts and cinnamon	
3576	649	Rice flour	
3577	649	Whole milk	
3578	649	Coconut milk powder or extract	
3579	649	Sugar	
3580	649	Vanilla extract	
3581	649	Cold water or ice cubes	
3582	650	Fresh raw sugarcane stalks	
3583	650	Ice cubes	
3584	651	Chicken breasts	
3585	651	Flour, beaten eggs, breadcrumbs	
3586	651	Napolitana tomato sauce	
3587	651	Sliced leg ham	
3588	651	Mozzarella and cheddar cheese	
3589	651	Cooking oil for shallow frying	
3590	652	Minced beef	
3591	652	Onion	
3592	652	Beef stock	
3593	652	Worcestershire sauce and tomato paste	
3594	652	Cornstarch slurry	
3595	652	Shortcrust pastry sheets	
3596	652	Puff pastry sheets	
3597	652	Egg wash	
3598	653	Fresh Barramundi fillets (skin-on)	
3599	653	Dried lemon myrtle leaves	
3600	653	Butter and olive oil	
3601	653	Fresh garlic	
3602	653	Sea salt and white pepper	
3603	653	Lemon wedges	
3604	654	Whole leg of lamb	
3605	654	Fresh garlic cloves	
3606	654	Fresh rosemary sprigs	
3607	654	Olive oil, salt, black pepper	
3608	654	Fresh mint leaves, sugar, white vinegar	
3609	655	Premium kangaroo loin fillets	
3610	655	Ground wattleseed	
3611	655	Crushed mountain pepperberries	
3612	655	Olive oil and salt	
3613	655	Red wine and plum jam	
3614	656	Thick beef or pork sausages (snags)	
3615	656	Slices of plain white sandwich bread	
3616	656	Onions	
3617	656	Tomato sauce or barbecue sauce	
3618	656	Vegetable oil	
3619	657	Thick-cut ribeye or scotch fillet steaks	
3620	657	Fresh shucked oysters	
3621	657	Butter	
3622	657	Toothpicks	
3623	657	Salt, black pepper, garlic powder	
3624	657	Brandy or red wine	
3625	658	Fresh squid tubes	
3626	658	Cornstarch or rice flour	
3627	658	Sea salt flakes	
3628	658	Crushed white and black peppercorns	
3629	658	Cooking oil for deep frying	
3630	658	Fresh chili and spring onion slices	
3631	659	Butternut pumpkin	
3632	659	Onion and garlic	
3633	659	Vegetable or chicken stock	
3634	659	Heavy cream and nutmeg	
3635	659	Self-rising flour, water, milk	
3636	660	Minced beef or pork	
3637	660	Breadcrumbs and egg	
3638	660	Garlic powder and onion powder	
3639	660	Fresh dark plums or plum jam	
3640	660	Barbecue sauce and Worcestershire sauce	
3641	661	Egg whites	
3642	661	Caster sugar	
3643	661	Cornstarch and white vinegar	
3644	661	Vanilla extract	
3645	661	Whipped cream	
3646	661	Fresh passionfruit pulp, strawberries, kiwi slices	
3647	662	Vanilla sponge cake	
3648	662	Icing sugar	
3649	662	Cocoa powder	
3650	662	Melted butter and boiling water	
3651	662	Desiccated coconut flakes	
3652	663	Rolled oats	
3653	663	Plain flour	
3654	663	Sugar	
3655	663	Desiccated coconut flakes	
3656	663	Butter	
3657	663	Golden syrup	
3658	663	Baking soda and boiling water	
3659	664	Self-rising flour	
3660	664	Butter	
3661	664	Milk	
3662	664	Golden syrup	
3663	664	Brown sugar and water	
3664	665	Puff pastry sheets	
3665	665	Whole milk and heavy cream	
3666	665	Custard powder or cornstarch	
3667	665	Sugar and vanilla extract	
3668	665	Icing sugar and passionfruit pulp	
3669	666	Shortcrust pastry tart shell	
3670	666	Raspberry jam	
3671	666	Marshmallows (melted) or pink frosting cream	
3672	666	Desiccated coconut flakes	
3673	667	Dried or fresh Quandong fruit	
3674	667	Sugar	
3675	667	Water	
3676	667	Shortcrust pastry sheets	
3677	667	Egg wash	
3678	668	Rice Bubbles (puffed rice cereal)	
3679	668	Icing sugar	
3680	668	Cocoa powder	
3681	668	Hydrogenated coconut oil (Kopha, melted)	
3682	668	Desiccated coconut flakes	
3683	669	Cannelloni pastry shells (fried crisp)	
3684	669	Heavy whipping cream	
3685	669	Sugar and golden syrup	
3686	669	Baking soda	
3687	670	Plain sweet biscuits	
3688	670	Melted butter	
3689	670	Sweetened condensed milk and gelatin powder	
3690	670	Fresh lemon juice	
3691	670	Packet of red raspberry or strawberry jelly crystals	
3692	671	Freshly ground espresso coffee beans	
3693	671	Whole milk	
3694	671	Hot water	
3695	672	Lemonade soda	
3696	672	Lime juice cordial	
3697	672	Angostura aromatic bitters	
3698	672	Fresh lemon and lime wheels	
3699	672	Ice cubes	
3700	673	Loose black tea leaves	
3701	673	Fresh eucalyptus (gum) leaf	
3702	673	Boiling water	
3703	674	Milo (Australian chocolate malt powder)	
3704	674	Whole milk	
3705	674	Sugar or condensed milk	
3706	674	Ice cubes	
3707	675	Fresh ginger root	
3708	675	Fresh lemon juice	
3709	675	Sugar	
3710	675	Water	
3711	675	Sparkling mineral water or club soda	
3712	676	Pork chops, lamb shoulders, or chicken pieces	
3713	676	Kūmara (New Zealand sweet potato)	
3714	676	Potatoes and pumpkins	
3715	676	Whole cabbage	
3716	676	Stuffing (bread crumbs and herbs)	
3717	676	Large canvas sacks or foil pockets	
3718	677	Whole leg of grass-fed New Zealand lamb	
3719	677	Garlic cloves	
3720	677	Fresh rosemary sprigs	
3721	677	Olive oil	
3722	677	Sea salt and coarsely ground black pepper	
3723	677	Gravy mix (pan drippings, flour, beef stock)	
3724	678	Minced beef	
3725	678	Onion	
3726	678	Beef stock, Worcester sauce, tomato paste	
3727	678	Cornstarch	
3728	678	Grated cheddar cheese or processed cheese slices	
3729	678	Shortcrust pastry sheets	
3730	678	Puff pastry sheets	
3731	678	Egg wash	
3732	679	Fresh New Zealand whitebait	
3733	679	Eggs	
3734	679	Flour	
3735	679	Salt and white pepper	
3736	679	Butter	
3737	679	Fresh white bread slices and lemon wedges	
3738	680	Fresh New Zealand green-lipped mussels	
3739	680	Garlic	
3740	680	Shallots or onions	
3741	680	Dry white wine	
3742	680	Heavy whipping cream	
3743	680	Fresh parsley	
3744	680	Butter	
3745	681	Pork bones (bacon bones or pork ribs)	
3746	681	Kūmara (sweet potato)	
3747	681	Potatoes and carrots	
3748	681	Fresh watercress or puha (sow thistle)	
3749	681	Flour and water	
3750	681	Salt	
3751	682	Slices of plain white sandwich bread	
3752	682	Grated cheddar cheese	
3753	682	Evaporated milk	
3754	682	Pack of French onion soup mix	
3755	682	Finely chopped onion	
3756	682	Butter	
3757	683	Strips of streaky bacon	
3758	683	Eggs	
3759	683	Onion	
3760	683	Puff pastry sheets	
3761	683	Salt and black pepper	
3762	683	Milk or egg wash	
3763	684	Leg of mutton or lamb (completely deboned)	
3764	684	Breadcrumbs	
3765	684	Onion	
3766	684	Fresh parsley, sage, thyme	
3767	684	Honey and milk	
3768	684	Kitchen twine	
3769	685	Fresh Pāua (New Zealand abalone, minced finely)	
3770	685	Onion or shallot	
3771	685	Egg	
3772	685	Flour	
3773	685	Splash of cream	
3774	685	Butter for frying	
3775	686	Egg whites	
3776	686	Caster sugar	
3777	686	White vinegar and cornstarch	
3778	686	Vanilla extract	
3779	686	Whipped heavy cream	
3780	686	Fresh kiwifruit and strawberries	
3781	687	Malt biscuits (crushed)	
3782	687	Explorer lollies or fruit puffs (firm marshmallow candies, chopped)	
3783	687	Sweetened condensed milk	
3784	687	Butter	
3785	687	Desiccated coconut flakes	
3786	688	Vanilla ice cream (store-bought or homemade base)	
3787	688	Sugar	
3788	688	Golden syrup	
3789	688	Baking soda	
3790	689	Flour and baking powder	
3791	689	Sugar	
3792	689	Butter	
3793	689	Ground ginger	
3794	689	Golden syrup and icing sugar	
3795	690	Flour, sugar, butter	
3796	690	Egg yolks	
3797	690	Raspberry jam	
3798	690	Desiccated coconut flakes	
3799	690	Caster sugar	
3800	690	Egg whites	
3801	691	Butter	
3802	691	Sugar and flour	
3803	691	Cocoa powder	
3804	691	Cornflakes (plain, un-frosted)	
3805	691	Chocolate icing sugar	
3806	691	Whole walnut halves	
3807	692	Fresh feijoas	
3808	692	Sugar	
3809	692	Rolled oats and flour	
3810	692	Brown sugar	
3811	692	Butter	
3812	693	Puff pastry sheets	
3813	693	Whole milk and heavy cream	
3814	693	Custard powder and cornstarch	
3815	693	Sugar and vanilla extract	
3816	693	Icing sugar and water	
3817	694	Butter	
3818	694	Sugar	
3819	694	Golden syrup	
3820	694	Flour and ground ginger	
3821	694	Heavy whipping cream	
3822	695	Yeast dough (flour, yeast, milk, butter, sugar)	
3823	695	Softened butter	
3824	695	Brown sugar and ground cinnamon	
3825	695	Mixed dried fruit (currants, raisins, citrus peel)	
3826	695	Sugar and water	
3827	696	Fresh lemon juice	
3828	696	Sugar syrup	
3829	696	Carbonated sparkling mineral water	
3830	697	Freshly ground coffee beans (espresso roast)	
3831	697	Whole milk	
3832	698	Fresh feijoa pulp	
3833	698	Fresh mint leaves	
3834	698	Lime wedges	
3835	698	White rum	
3836	698	Soda water	
3837	698	Sugar syrup	
3838	699	Fresh or dried Kawakawa leaves	
3839	699	Boiling water	
3840	699	Mānuka honey	
3841	700	Vanilla or Hokey Pokey ice cream	
3842	700	Cold whole milk	
3843	700	Golden syrup	
3844	700	Crushed hokey pokey (honeycomb toffee pieces)	
3845	701	Fresh white fish fillets (mahi-mahi or snapper, cubed)	
3846	701	Fresh lime juice	
3847	701	Thick coconut cream (miti)	
3848	701	Onions and tomatoes	
3849	701	Red and green chilies	
3850	701	Spring onions	
3851	701	Salt	
3852	702	Whole chicken pieces or pork shoulders	
3853	702	Garlic, ginger, onions	
3854	702	Soy sauce and oil	
3855	702	Salt and wild herbs	
3856	702	Large banana leaves	
3857	702	Coconut fronds	
3858	703	Fresh rourou leaves (young taro leaves)	
3859	703	Coconut cream	
3860	703	Onion	
3861	703	Garlic and ginger	
3862	703	Green chilies	
3863	703	Salt	
3864	704	Firm white fish fillets	
3865	704	Coconut milk	
3866	704	Onions	
3867	704	Garlic and ginger	
3868	704	Curry powder, turmeric, cumin seeds	
3869	704	Fresh tomatoes	
3870	704	Cooking oil and salt	
3871	705	Fresh cassava root	
3872	705	Fresh coconut cream	
3873	705	Sugar or brown sugar	
3874	705	Banana leaves	
3875	706	Fresh octopus	
3876	706	Garam masala and curry powder	
3877	706	Coconut milk	
3878	706	Onions, garlic, ginger	
3879	706	Fresh red chilies	
3880	706	Lemon juice	
3881	707	Large eggplants	
3882	707	Canned or fresh minced fish flesh	
3883	707	Onions and green chilies	
3884	707	Coconut cream	
3885	707	Salt and pepper	
3886	708	Lamb chops	
3887	708	Hot curry powder and chili powder	
3888	708	Mustard seeds and cumin seeds	
3889	708	Onions, garlic, ginger	
3890	708	Curry leaves	
3891	708	Cooking oil and salt	
3892	709	Whole reef fish	
3893	709	Thick coconut cream	
3894	709	Onions	
3895	709	Tomatoes	
3896	709	Lemon juice and salt	
3897	709	Oil for shallow frying	
3898	710	Fresh rourou leaves (young taro leaves)	
3899	710	Corned beef or minced lamb	
3900	710	Thick coconut cream	
3901	710	Onions and garlic	
3902	710	Aluminum foil or banana leaves	
3903	711	Cassava	
3904	711	Brown sugar or molasses	
3905	711	Desiccated coconut flakes	
3906	711	Spices (cinnamon, cloves, ground ginger)	
3907	711	Thick coconut cream	
3908	711	Banana leaves	
3909	712	Sugar	
3910	712	Boiling water	
3911	712	Thick coconut milk	
3912	712	Flour and baking powder	
3913	712	Melted butter	
3914	712	Raisins	
3915	713	Flour and sugar	
3916	713	Active dry yeast	
3917	713	Warm water	
3918	713	Salt	
3919	713	Vegetable oil for deep frying	
3920	714	Bread flour, sugar, yeast	
3921	714	Warm water	
3922	714	Melted butter	
3923	714	Coconut milk mixed with extra sugar	
3924	715	Very ripe bananas	
3925	715	Flour and sugar	
3926	715	Milk or water	
3927	715	Baking powder	
3928	715	Oil for shallow frying	
3929	716	Cassava	
3930	716	Freshly grated coconut flesh	
3931	716	Brown sugar	
3932	716	Thick coconut cream	
3933	717	Shredded or desiccated coconut flakes	
3934	717	Condensed milk	
3935	717	Egg whites	
3936	717	Vanilla extract	
3937	717	Salt	
3938	718	Ripe bananas	
3939	718	Flour	
3940	718	Sugar	
3941	718	Coconut milk	
3942	719	Shortcrust pastry sheet	
3943	719	Whole milk	
3944	719	Eggs	
3945	719	Sugar	
3946	719	Custard powder or cornstarch	
3947	719	Yellow food coloring	
3948	719	Vanilla essence	
3949	720	Dried kava root powder (Yaqona)	
3950	720	Cold water	
3951	720	Cloth straining bag (bilo bag)	
3952	721	Fresh leaves from a lemon, lime, or orange tree	
3953	721	Boiling water	
3954	721	Sugar or honey	
3955	722	Fresh green coconuts (bu)	
3956	722	Ice cubes	
3957	723	Fiji Gold lager beer (or any light lager, chilled)	
3958	723	Carbonated lemonade soda (chilled)	
3959	723	Fresh lime wheel	
3960	724	Fresh lemongrass stalks	
3961	724	Fresh pineapple juice	
3962	724	Water	
3963	724	Sugar syrup	
3964	724	Ice cubes and mint leaves	
3965	725	Chicken thighs and drumsticks	
3966	725	Red wine (Burgundy or Pinot Noir)	
3967	725	Lardons or thick-cut bacon	
3968	725	Button mushrooms	
3969	725	Pearl onions	
3970	725	Garlic	
3971	725	Tomato paste and chicken stock	
3972	725	Butter and flour	
3973	726	Beef chuck or stewing beef	
3974	726	Red wine (Burgundy style)	
3975	726	Beef stock	
3976	726	Carrots	
3977	726	Bacon or lardons	
3978	726	Pearl onions and mushrooms	
3979	726	Garlic, thyme, bay leaves	
3980	726	Flour and butter	
3981	727	Eggplant	
3982	727	Zucchini	
3983	727	Yellow squash or bell peppers	
3984	727	Tomatoes	
3985	727	Canned crushed tomatoes and tomato paste	
3986	727	Onions and garlic	
3987	727	Olive oil	
3988	727	Herbes de Provence	
3989	728	Whole duck legs	
3990	728	Coarse sea salt	
3991	728	Fresh thyme sprigs and garlic cloves	
3992	728	Black peppercorns and bay leaves	
3993	728	Rendered duck fat	
3994	729	Whole sole or flounder fillets	
3995	729	All-purpose flour	
3996	729	Unsalted butter	
3997	729	Fresh lemon juice	
3998	729	Fresh flat-leaf parsley	
3999	729	Salt and white pepper	
4000	730	Shortcrust pastry sheet	
4001	730	Thick-cut bacon or lardons	
4002	730	Eggs and heavy cream	
4003	730	Gruyère or Swiss cheese	
4004	730	Nutmeg	
4005	730	Salt and white pepper	
4006	731	Mixed seafood (firm white fish chunks, mussels, clams, prawns)	
4007	731	Fennel bulb and onions	
4008	731	Tomatoes (crushed) and tomato paste	
4009	731	Garlic and leeks	
4010	731	Saffron threads	
4011	731	Orange peel strip	
4012	731	Fish stock and olive oil	
4013	732	Tarbais or cannellini white beans	
4014	732	French garlic sausages or pork sausages	
4015	732	Duck confit legs	
4016	732	Pork belly chunks	
4017	732	Onions, carrots, garlic	
4018	732	Tomato paste and chicken stock	
4019	732	Fresh breadcrumbs	
4020	733	Slices of thick white sourdough bread	
4021	733	French cooked ham	
4022	733	Gruyère or Comté cheese	
4023	733	Dijon mustard	
4024	733	Butter and flour	
4025	733	Whole milk and nutmeg	
4026	734	Ribeye, flank, or entrecôte steak	
4027	734	Russet potatoes	
4028	734	Butter, shallots, fresh tarragon	
4029	734	Vegetable oil for deep frying	
4030	734	Salt and coarsely cracked black pepper	
4031	735	Heavy whipping cream	
4032	735	Egg yolks	
4033	735	Caster sugar	
4034	735	Whole vanilla bean pod	
4035	736	Crisp apples	
4036	736	Sugar	
4037	736	Unsalted butter	
4038	736	Puff pastry sheet	
4039	737	Almond flour	
4040	737	Icing sugar	
4041	737	Egg whites	
4042	737	Caster sugar	
4043	737	Chocolate ganache or fruit jam	
4044	738	Water, butter, flour, eggs	
4045	738	Vanilla ice cream	
4046	738	Dark chocolate chunks	
4047	738	Heavy cream	
4048	739	Choux pastry dough	
4049	739	Pastry cream (milk, sugar, egg yolks, cornstarch, vanilla)	
4050	739	Dark chocolate and butter	
4051	740	Eggs and caster sugar	
4052	740	All-purpose flour and baking powder	
4053	740	Unsalted butter	
4054	740	Fresh lemon zest	
4055	741	Dark chocolate	
4056	741	Butter and flour	
4057	741	Whole milk	
4058	741	Egg yolks and egg whites	
4059	741	Sugar	
4060	742	Puff pastry sheets	
4061	742	Vanilla pastry cream	
4062	742	Icing sugar and cocoa powder	
4063	743	Flour, sugar, eggs, milk, melted butter	
4064	743	Heavy whipping cream	
4065	743	Vanilla pastry cream	
4066	744	Choux pastry dough	
4067	744	Sliced blanched almonds	
4068	744	Praline paste	
4069	744	Butter and pastry cream	
4070	744	Powdered sugar	
4071	745	Coarsely ground coffee beans	
4072	745	Hot water	
4073	746	High-quality dark chocolate bar (70% cocoa)	
4074	746	Whole milk	
4075	746	Heavy cream	
4076	746	Sugar	
4077	747	Crème de Cassis (sweet French blackcurrant liqueur)	
4078	747	Chilled French Champagne or sparkling wine	
4079	748	Fresh lemons	
4080	748	Sugar	
4081	748	Water	
4082	748	Ice cubes and fresh mint leaves	
4083	749	Strong brewed dark roast coffee or chicory coffee	
4084	749	Whole milk	
4085	750	Beef chuck or round roast	
4086	750	Red wine vinegar and dry red wine	
4087	750	Onions, carrots, celery	
4088	750	Juniper berries, cloves, bay leaves	
4089	750	Lebkuchen (German gingerbread cookies) or gingersnaps	
4090	750	Oil and salt	
4091	751	Veal cutlets or pork loins	
4092	751	All-purpose flour	
4093	751	Eggs	
4094	751	Plain breadcrumbs	
4095	751	Lard or clarified butter	
4096	751	Salt and black pepper	
4097	751	Lemon slices	
4098	752	Thinly sliced beef top round steaks	
4099	752	German spicy mustard (Senf)	
4100	752	Strips of smoky bacon	
4101	752	Onions	
4102	752	German dill pickles	
4103	752	Beef stock and red wine	
4104	752	Butter and flour	
4105	753	Flour and eggs	
4106	753	Sparkling water or milk	
4107	753	Grated Emmental and Gruyère cheese	
4108	753	Onions	
4109	753	Butter	
4110	753	Salt and nutmeg	
4111	754	Minced pork and veal mixture	
4112	754	Stale bread roll	
4113	754	Egg	
4114	754	Onions	
4115	754	Anchovy fillets	
4116	754	Beef or veal stock	
4117	754	Butter and flour	
4118	754	Heavy cream and capers	
4119	755	Bratwurst or Bockwurst pork sausages	
4120	755	Tomato paste or ketchup	
4121	755	Yellow curry powder	
4122	755	Worcestershire sauce and vinegar	
4123	755	Sugar and onion powder	
4124	755	Vegetable oil for frying	
4125	756	Whole pork knuckle (Schweinshaxe, skin-on)	
4126	756	Garlic cloves	
4127	756	Caraway seeds	
4128	756	German lager beer	
4129	756	Onions and carrots	
4130	756	Salt	
4131	757	Cured pork knuckle (pickled/salted)	
4132	757	Onions	
4133	757	Bay leaves, juniper berries, black peppercorns	
4134	757	Fresh garlic cloves	
4135	757	Water	
4136	758	Pasta dough sheets	
4137	758	Minced beef or pork	
4138	758	Fresh spinach	
4139	758	Stale bread roll	
4140	758	Onions and parsley	
4141	758	Egg	
4142	758	Rich beef broth	
4143	759	Lean pork and beef	
4144	759	Bacon fat	
4145	759	Ice water or crushed ice	
4146	759	Onion powder and ground marjoram	
4147	759	Salt and pink curing salt	
4148	760	Strudel dough or puff pastry	
4149	760	Tart cooking apples	
4150	760	Raisins	
4151	760	Sugar and ground cinnamon	
4152	760	Breadcrumbs toasted in butter	
4153	760	Melted butter	
4154	761	Chocolate sponge cake layers	
4155	761	Kirschwasser (German clear cherry brandy)	
4156	761	Tart sour cherries	
4157	761	Heavy whipping cream and vanilla sugar	
4158	761	Dark chocolate block	
4159	762	Mixed red berries (raspberries, red currants, blackberries, sour cherries)	
4160	762	Red currant juice or cherry juice	
4161	762	Sugar	
4162	762	Cornstarch	
4163	762	Vanilla sauce or liquid cream	
4164	763	Shortcrust pastry dough	
4165	763	Quark cheese (or drained Greek yogurt/sour cream mixture)	
4166	763	Eggs	
4167	763	Sugar and vanilla pudding powder	
4168	763	Lemon zest and juice	
4169	764	Premium vanilla ice cream	
4170	764	Sweet strawberry sauce or puree	
4171	764	White chocolate block	
4172	764	Whipped cream	
4173	765	Sweet yeast dough	
4174	765	Sliced almonds	
4175	765	Butter, honey, sugar	
4176	765	Vanilla pastry cream or heavy cream	
4177	766	Yeast dough (flour, yeast, milk, sugar, butter)	
4178	766	Whole milk	
4179	766	Butter	
4180	766	Sugar	
4181	766	Warm vanilla custard sauce	
4182	767	Flour, milk, egg yolks	
4183	767	Egg whites	
4184	767	Sugar and raisins	
4185	767	Butter	
4186	767	Powdered sugar and plum compote	
4187	768	Rich yeast dough (flour, butter, egg yolks, milk, sugar)	
4188	768	Red fruit jam (raspberry, strawberry, or plum)	
4189	768	Oil for deep frying	
4190	768	Fine sugar or icing sugar	
4191	769	Ground almonds or hazelnuts	
4192	769	Egg whites	
4193	769	Icing sugar	
4194	769	Ground cinnamon	
4195	769	Salt	
4196	770	Classic cola soda	
4197	770	Fanta or fruit orange soda	
4198	770	Ice cubes and orange slice	
4199	771	High-quality clear apple juice	
4200	771	Highly carbonated sparkling mineral water (Sprudelwasser)	
4201	772	Dry red wine (Pinot Noir or Dornfelder)	
4202	772	Orange	
4203	772	Cinnamon sticks	
4204	772	Whole cloves and star anise	
4205	772	Sugar	
4206	773	German Pilsner or Helles pale lager beer	
4207	773	Clear lemon-lime sparkling lemonade soda	
4208	774	Strong coffee or espresso	
4209	774	Vanilla ice cream	
4210	774	Whipped cream	
4211	774	Cocoa powder or chocolate shavings	
4212	775	Minced beef and minced pork	
4213	775	Soffritto (onion, carrot, celery)	
4214	775	Whole milk	
4215	775	Dry white or red wine	
4216	775	Tomato paste or passata	
4217	775	Beef stock	
4218	775	Fresh tagliatelle pasta sheets	
4219	775	Olive oil, butter, salt	
4220	776	Carnaroli or Arborio rice	
4221	776	Saffron threads	
4222	776	Beef bone marrow or butter	
4223	776	Onions	
4224	776	Dry white wine	
4225	776	Rich beef or chicken stock	
4226	776	Parmigiano-Reggiano cheese	
4227	777	Veal shanks	
4228	777	All-purpose flour	
4229	777	Onions, carrots, celery	
4230	777	Dry white wine	
4231	777	Veal or beef stock	
4232	777	Canned plum tomatoes	
4233	777	Gremolata (lemon zest, garlic, parsley)	
4234	777	Butter and olive oil	
4235	778	Fresh potato gnocchi	
4236	778	Tomato passata or canned San Marzano tomatoes	
4237	778	Garlic cloves	
4238	778	Fresh mozzarella or Fior di Latte	
4239	778	Parmigiano-Reggiano	
4240	778	Fresh basil leaves	
4241	778	Extra virgin olive oil and salt	
4242	779	Whole chicken	
4243	779	Red onion and bell peppers	
4244	779	Garlic cloves	
4245	779	Canned plum tomatoes	
4246	779	Dry red or white wine	
4247	779	Black olives	
4248	779	Fresh rosemary and thyme	
4249	779	Olive oil, salt, pepper	
4250	780	Large eggplants	
4251	780	Coarse salt	
4252	780	Italian tomato sauce	
4253	780	Mozzarella cheese	
4254	780	Parmigiano-Reggiano	
4255	780	Oil for shallow frying	
4256	781	Spaghetti pasta	
4257	781	Fresh clams	
4258	781	Garlic cloves	
4259	781	Dried red chili flakes	
4260	781	Dry white wine	
4261	781	Fresh flat-leaf parsley	
4262	781	Extra virgin olive oil	
4263	782	Veal cutlets	
4264	782	Prosciutto di Parma slices	
4265	782	Fresh sage leaves	
4266	782	All-purpose flour	
4267	782	Dry white wine	
4268	782	Unsalted butter and olive oil	
4269	782	Toothpicks	
4270	783	Thick T-bone steak	
4271	783	Extra virgin olive oil	
4272	783	Coarse sea salt and cracked black pepper	
4273	783	Fresh rosemary sprigs	
4274	784	Whole pork belly	
4275	784	Garlic cloves	
4276	784	Fresh rosemary and sage leaves	
4277	784	Fennel seeds	
4278	784	Crushed red chili flakes	
4279	784	Coarse salt and black pepper	
4280	785	Savoiardi (Italian ladyfinger biscuits)	
4281	785	Fresh espresso coffee	
4282	785	Mascarpone cheese	
4283	785	Eggs	
4284	785	Caster sugar	
4285	785	Dark cocoa powder	
4286	786	Heavy whipping cream	
4287	786	Whole milk	
4288	786	Sugar	
4289	786	Vanilla bean pod	
4290	786	Gelatin leaves or powder	
4291	786	Mixed berries and lemon juice	
4292	787	Cannoli shells (fried pastry tubes made with Marsala wine)	
4293	787	Fresh sheep's milk ricotta	
4294	787	Icing sugar	
4295	787	Vanilla extract or orange zest	
4296	787	Mini dark chocolate chips	
4297	787	Chopped pistachios	
4298	788	Dark chocolate	
4299	788	Blanched almonds	
4300	788	Unsalted butter	
4301	788	Caster sugar	
4302	788	Eggs	
4303	788	Powdered sugar	
4304	789	Whole milk and heavy cream	
4305	789	Sugar	
4306	789	Egg yolks	
4307	789	100% pure roasted pistachio paste	
4308	789	Sea salt	
4309	790	Fiordilatte or vanilla gelato	
4310	790	Freshly brewed hot espresso coffee	
4311	790	Amaretti cookie crumbs	
4312	791	Flour and sugar	
4313	791	Eggs	
4314	791	Whole blanched almonds	
4315	791	Orange zest and vanilla extract	
4316	791	Glass of Vin Santo	
4317	792	Strong brewed espresso coffee	
4318	792	Water and sugar	
4319	792	Heavy whipping cream	
4320	793	Pasta frolla (flour, sugar, cold butter, eggs, lemon zest)	
4321	793	High-quality fruit jam (apricot, cherry, or plum)	
4322	794	Strong bread flour and active wild yeast (lievito madre)	
4323	794	Large amounts of butter and egg yolks	
4324	794	Sugar and honey	
4325	794	Candied orange and citron peel	
4326	794	Raisins	
4327	794	Vanilla bean extract	
4328	795	Finely ground coffee beans	
4329	795	Filtered hot water	
4330	796	Aperol	
4331	796	Chilled Prosecco sparkling wine	
4332	796	Soda water or sparkling mineral water	
4333	796	Large ice cubes	
4334	796	Fresh orange slice	
4335	797	Fresh organic lemons	
4336	797	Pure grain alcohol (95% ABV or high-proof vodka)	
4337	797	Water and sugar	
4338	798	London Dry Gin	
4339	798	Sweet red vermouth (Vermouth Rosso)	
4340	798	Campari	
4341	798	Large ice cubes	
4342	798	Fresh orange peel strip	
4343	799	Commercial Chinotto soda	
4344	799	Ice cubes	
4345	799	Fresh lemon or orange slice	
4346	800	Bomba or Calasparra rice	
4347	800	Chicken and rabbit pieces	
4348	800	Garrofó (white lima beans) and flat green beans	
4349	800	Grated ripe tomatoes	
4350	800	Saffron threads	
4351	800	Sweet Spanish paprika	
4352	800	Rosemary sprigs	
4353	800	Olive oil and rich chicken or vegetable stock	
4354	801	Russet or Yukon Gold potatoes	
4355	801	Yellow onions	
4356	801	Large eggs	
4357	801	Extra virgin olive oil	
4358	801	Sea salt	
4359	802	Large prawns or shrimp	
4360	802	Garlic cloves	
4361	802	Dried red cayenne chilis or guindilla peppers	
4362	802	Extra virgin olive oil	
4363	802	Dry sherry wine	
4364	802	Fresh flat-leaf parsley	
4365	803	Dried chickpeas	
4366	803	Beef brisket and pork belly	
4367	803	Chorizo and morcilla (Spanish blood sausage)	
4368	803	Ham hock or Jamón bone	
4369	803	Cabbage, carrots, potatoes	
4370	803	Fine soup noodles (fideos)	
4371	804	Whole octopus	
4372	804	Yukon Gold potatoes	
4373	804	Sweet and spicy Spanish smoked paprika	
4374	804	Flaky sea salt	
4375	804	Extra virgin olive oil	
4376	804	Whole onion	
4377	805	Quarter or half of a milk-fed lamb (lechazo)	
4378	805	Lard or olive oil	
4379	805	Water	
4380	805	Coarse salt	
4381	805	Garlic cloves and white wine vinegar	
4382	806	Ripe plum tomatoes	
4383	806	Green bell pepper and cucumber	
4384	806	Garlic clove	
4385	806	Stale white bread crusts	
4386	806	Sherry vinegar	
4387	806	Extra virgin olive oil	
4388	806	Cold water and salt	
4389	807	Asturian faba beans	
4390	807	Spanish chorizo sausages	
4391	807	Asturian morcilla (smoky blood sausage)	
4392	807	Pancetta or salted pork belly	
4393	807	Saffron threads	
4394	807	Sweet paprika	
4395	807	Whole onion	
4396	808	Pork cheeks	
4397	808	Onions, carrots, leeks	
4398	808	Garlic cloves	
4399	808	Dry Spanish red wine	
4400	808	Beef or pork stock	
4401	808	Bay leaves and cinnamon stick	
4402	808	Flour and olive oil	
4403	809	Salted cod fillets (bacalao, desalted in water for 48 hours)	
4404	809	Garlic cloves	
4405	809	Dried red chili pepper rings	
4406	809	Extra virgin olive oil	
4407	810	All-purpose flour	
4408	810	Boiling water	
4409	810	Salt and oil	
4410	810	High-quality dark chocolate	
4411	810	Whole milk and cornstarch	
4412	810	Oil for frying and sugar	
4413	811	Whole milk	
4414	811	Egg yolks	
4415	811	Sugar	
4416	811	Cinnamon stick	
4417	811	Fresh orange and lemon peels	
4418	811	Cornstarch	
4419	812	Finely ground blanched almonds	
4420	812	Eggs	
4421	812	Caster sugar	
4422	812	Fresh lemon zest	
4423	812	Ground cinnamon	
4424	812	Powdered sugar	
4425	812	Cross of Saint James paper stencil	
4426	813	Stale white bread	
4427	813	Whole milk	
4428	813	Sugar	
4429	813	Cinnamon stick and lemon peel	
4430	813	Beaten eggs	
4431	813	Olive oil or butter	
4432	813	Cinnamon sugar mixture	
4433	814	Full-fat cream cheese	
4434	814	Caster sugar	
4435	814	Large eggs	
4436	814	Heavy whipping cream	
4437	814	All-purpose flour	
4438	814	Salt	
4439	815	Fresh milk curds (cuajada) or ricotta cheese	
4440	815	Unsalted butter	
4441	815	Sugar and flour	
4442	815	Large eggs	
4443	815	Lemon zest and ground cinnamon	
4444	816	All-purpose flour	
4445	816	High-quality lard (manteca de cerdo)	
4446	816	Icing sugar	
4447	816	Toasted ground almonds	
4448	816	Ground cinnamon	
4449	816	Powdered sugar	
4450	817	Whole milk	
4451	817	Cornstarch and flour	
4452	817	Sugar	
4453	817	Cinnamon stick and lemon peel	
4454	817	Beaten eggs and extra flour	
4455	817	Oil for shallow frying	
4456	818	Egg yolks	
4457	818	Sugar and water	
4458	818	Extra sugar and water (for caramel coating)	
4459	819	Strong bread flour	
4460	819	Water, sugar, eggs	
4461	819	Active dry yeast	
4462	819	Pork lard (saïm)	
4463	819	Powdered sugar	
4464	820	Spanish red wine (Tempranillo or Garnacha)	
4465	820	Brandy or orange liqueur	
4466	820	Fresh oranges, lemons, apples	
4467	820	Sugar or simple syrup	
4468	820	Cinnamon stick	
4469	820	Soda water	
4470	821	Sweetened condensed milk	
4471	821	Freshly brewed hot espresso coffee	
4472	822	Spanish red wine	
4473	822	Gaseosa (traditional light Spanish soda) or lemon-lime soda	
4474	822	Fresh lemon or orange slice	
4475	822	Large ice cubes	
4476	823	Chufas (dried tiger nuts)	
4477	823	Cold water	
4478	823	Caster sugar	
4479	823	Ground cinnamon or lemon peel	
4480	824	Cold Spanish pale lager beer	
4481	824	Carbonated lemonade or lemon soda (Fanta Limón)	
4482	824	Fresh lemon wedge	
4483	825	Whole packer beef brisket (untrimmed)	
4484	825	Coarse sea salt	
4485	825	Coarse black pepper	
4486	825	Post oak wood chunks	
4487	826	Whole chicken	
4488	826	Buttermilk	
4489	826	Hot sauce (Louisiana style)	
4490	826	All-purpose flour and cornstarch	
4491	826	Seasoning blend (garlic powder, onion powder, paprika, cayenne, salt, black pepper)	
4492	826	Peanut oil or vegetable oil	
4493	827	Jumbo lump Maryland blue crab meat	
4494	827	Mayonnaise	
4495	827	Egg	
4496	827	Dijon mustard and Worcestershire sauce	
4497	827	Old Bay seasoning	
4498	827	Saltine crackers	
4499	827	Unsalted butter	
4500	828	Fresh sea clams	
4501	828	Smoky bacon	
4502	828	Yellow onions and celery	
4503	828	Russet potatoes	
4504	828	Heavy cream and whole milk	
4505	828	All-purpose flour	
4506	828	Fresh thyme and bay leaf	
4507	828	Butter, salt, cracked black pepper	
4508	829	Chicken wings	
4509	829	Frank's RedHot original cayenne pepper sauce	
4510	829	Unsalted butter	
4511	829	White vinegar and garlic powder	
4512	829	Vegetable oil for deep frying	
4513	829	Celery sticks and blue cheese dressing	
4514	830	Long-grain white rice	
4515	830	Boneless chicken thighs	
4516	830	Smoked andouille sausage	
4517	830	Gulf shrimp	
4518	830	Holy Trinity (onion, green bell pepper, celery)	
4519	830	Garlic and canned crushed tomatoes	
4520	830	Cajun/Creole spice blend	
4521	830	Chicken stock	
4522	831	Beef ribeye steak	
4523	831	Yellow onions	
4524	831	Cheez Whiz or Provolone cheese	
4525	831	Fresh Italian hoagie rolls	
4526	831	Vegetable oil or beef tallow	
4527	832	Deep-dish pizza dough (with cornmeal and butter)	
4528	832	Sliced low-moisture mozzarella cheese	
4529	832	Raw Italian sausage	
4530	832	Chunky San Marzano tomato sauce	
4531	832	Grated Pecorino Romano cheese	
4532	832	Olive oil or butter	
4533	833	Large shrimp	
4534	833	Stone-ground yellow or white corn grits	
4535	833	Sharp cheddar cheese	
4536	833	Bacon strips	
4537	833	Green bell pepper, onions, garlic	
4538	833	Whole milk, heavy cream, chicken stock	
4539	833	Fresh lemon juice and chopped green onions	
4540	834	Ground beef chuck (80/20 blend)	
4541	834	Plain breadcrumbs or crushed saltine crackers	
4542	834	Milk and eggs	
4543	834	Yellow onions and garlic	
4544	834	Worcestershire sauce	
4545	834	Ketchup, brown sugar, apple cider vinegar	
4546	834	Salt, pepper, dried parsley	
4547	835	Graham cracker crumbs, sugar, melted butter	
4548	835	Full-fat cream cheese	
4549	835	Sugar and flour	
4550	835	Sour cream or heavy cream	
4551	835	Whole eggs	
4552	835	Vanilla extract and fresh lemon zest	
4553	836	Double crust pie pastry sheets	
4554	836	Tart cooking apples (Granny Smith)	
4555	836	Granulated sugar and brown sugar	
4556	836	All-purpose flour or cornstarch	
4557	836	Ground cinnamon, nutmeg, salt	
4558	836	Fresh lemon juice	
4559	836	Egg wash and sanding sugar	
4560	837	Unsalted butter	
4561	837	Granulated sugar and dark brown sugar	
4562	837	Dutch-process cocoa powder and melted dark chocolate	
4563	837	Eggs	
4564	837	All-purpose flour	
4565	837	Vanilla extract and sea salt	
4566	838	All-purpose flour and baking soda	
4567	838	Unsalted butter	
4568	838	Granulated sugar and dark brown sugar	
4569	838	Eggs	
4570	838	Semi-sweet chocolate chips	
4571	838	Vanilla extract and sea salt	
4572	839	Graham cracker crumbs, sugar, melted butter	
4573	839	Sweetened condensed milk	
4574	839	Egg yolks	
4575	839	Fresh Key lime juice and lime zest	
4576	839	Fresh whipped cream	
4577	840	Single crust pie pastry sheet	
4578	840	Raw pecan halves	
4579	840	Dark brown sugar	
4580	840	Dark corn syrup or pure maple syrup	
4581	840	Unsalted butter	
4582	840	Whole eggs	
4583	840	Vanilla extract and salt	
4584	841	Fresh ripe peaches	
4585	841	Granulated sugar and brown sugar	
4586	841	Cornstarch and lemon juice	
4587	841	All-purpose flour, sugar, baking powder	
4588	841	Unsalted butter	
4589	841	Boiling water or buttermilk	
4590	842	Cake flour and unsweetened cocoa powder	
4591	842	Granulated sugar and vegetable oil	
4592	842	Eggs	
4593	842	Buttermilk and white vinegar	
4594	842	Baking soda	
4595	842	Red food coloring	
4596	842	Cream cheese, butter, icing sugar	
4597	843	Nilla Wafer cookies	
4598	843	Fresh ripe bananas	
4599	843	Whole milk	
4600	843	Sugar and cornstarch	
4601	843	Egg yolks and vanilla extract	
4602	843	Heavy whipping cream	
4603	844	Oreo cookie crumbs and melted butter	
4604	844	Bittersweet chocolate and butter	
4605	844	Eggs and sugar	
4606	844	Instant chocolate pudding mixture	
4607	844	Whipped cream and chocolate curls	
4608	845	Black tea bags (Luzianne or Lipton)	
4609	845	Water	
4610	845	Granulated white sugar	
4611	845	Baking soda	
4612	845	Ice cubes and lemon wheels	
4613	846	Bourbon or Rye whiskey	
4614	846	Angostura aromatic bitters	
4615	846	Sugar cube or simple syrup	
4616	846	Splash of warm water	
4617	846	Large clear ice sphere	
4618	846	Fresh orange peel strip	
4619	847	Premium root beer soda	
4620	847	High-quality vanilla bean ice cream	
4621	848	Premium Kentucky Bourbon whiskey	
4622	848	Fresh mint leaves	
4623	848	Simple syrup or powdered sugar	
4624	848	Crushed ice	
4625	848	Fresh mint sprig	
4626	849	Fresh unfiltered apple cider juice	
4627	849	Cinnamon sticks	
4628	849	Whole cloves and whole allspice berries	
4629	849	Fresh orange	
4630	849	Fresh nutmeg	
4631	850	Dried chilies (Ancho, Pasilla, Mulato)	
4632	850	Mexican chocolate	
4633	850	Chicken pieces	
4634	850	Onions and garlic	
4635	850	Nuts and seeds (peanuts, almonds, pumpkin seeds, sesame)	
4636	850	Spices (cinnamon, cloves, anise, black peppercorns)	
4637	850	Raisins and plantains	
4638	850	Corn tortillas	
4639	850	Chicken broth and lard	
4640	851	Pork shoulder or leg	
4641	851	Achiote paste	
4642	851	Dried Guajillo and Ancho chilies	
4643	851	Pineapple juice and white vinegar	
4644	851	Garlic, oregano, cumin, cloves	
4645	851	Fresh white corn tortillas	
4646	851	Fresh pineapple	
4647	851	Cilantro and white onions	
4648	852	Large Poblano peppers	
4649	852	Ground pork and beef	
4650	852	Onions and garlic	
4651	852	Fruits (apple, pear, peach)	
4652	852	Raisins, almonds, pine nuts	
4653	852	Fresh walnuts	
4654	852	Queso fresco or goat cheese	
4655	852	Heavy cream and sherry wine	
4656	852	Fresh pomegranate seeds and parsley	
4657	853	Pork shoulder and pork shanks	
4658	853	Cacahuazintle hominy	
4659	853	Dried Guajillo and Ancho chilies	
4660	853	Garlic cloves and yellow onion	
4661	853	Dried Mexican oregano	
4662	853	Shredded cabbage, sliced radishes, diced onions, lime wedges, tostadas	
4663	854	Pork shoulder	
4664	854	Pure lard	
4665	854	Fresh orange	
4666	854	Sweetened condensed milk	
4667	854	Garlic cloves and white onion	
4668	854	Bay leaves and dried Mexican oregano	
4669	854	Coca-Cola or Mexican beer	
4670	855	Pork shoulder or pork butt	
4671	855	Achiote paste	
4672	855	Bitter Seville orange juice	
4673	855	Garlic cloves	
4674	855	Dried Mexican oregano, cumin, allspice	
4675	855	Fresh banana leaves	
4676	855	Pickled red onions with habanero peppers	
4677	856	Fresh corn tortillas	
4678	856	Cooked chicken breast	
4679	856	Fresh tomatillos	
4680	856	Serrano or jalapeño peppers	
4681	856	Fresh cilantro leaves and garlic	
4682	856	White onion	
4683	856	Mexican crema	
4684	856	Queso fresco	
4685	856	Vegetable oil	
4686	857	Beef chuck roast, short ribs, or shank	
4687	857	Dried Guajillo, Ancho, and Cascabel chilies	
4688	857	Roma tomatoes	
4689	857	Garlic cloves, ginger, white onion	
4690	857	Spices (cinnamon stick, cloves, cumin, Mexican oregano, thyme)	
4691	857	Apple cider vinegar	
4692	857	Corn tortillas and melting cheese	
4693	858	Stale corn tortillas	
4694	858	Roma tomatoes and dried Guajillo chilies	
4695	858	Garlic clove and white onion	
4696	858	Epazote sprig	
4697	858	Mexican crema and crumbled Cotija cheese	
4698	858	Fried or scrambled eggs	
4699	858	Vegetable oil	
4700	859	Fresh jumbo shrimp	
4701	859	Fresh lime juice	
4702	859	Fresh serrano or jalapeño peppers	
4703	859	Fresh cilantro leaves	
4704	859	English cucumber	
4705	859	Red onion	
4706	859	Tostadas and avocado slices	
4707	859	Sea salt and black pepper	
4708	860	Granulated white sugar	
4709	860	Sweetened condensed milk	
4710	860	Evaporated milk	
4711	860	Cream cheese	
4712	860	Whole eggs	
4713	860	Vanilla extract	
4714	861	Cake flour, baking powder, sugar	
4715	861	Eggs	
4716	861	Sweetened condensed milk	
4717	861	Evaporated milk	
4718	861	Heavy whipping cream	
4719	861	Vanilla extract	
4720	861	Heavy cream and powdered sugar	
4721	861	Ground cinnamon	
4722	862	All-purpose flour	
4723	862	Water, butter, salt	
4724	862	Eggs	
4725	862	Granulated sugar and ground cinnamon	
4726	862	Cajeta de Celaya (goat's milk caramel paste)	
4727	862	Vegetable oil	
4728	863	Strong bread flour	
4729	863	Active dry yeast, milk, sugar	
4730	863	Large eggs and unsalted butter	
4731	863	Fresh orange zest and orange blossom water	
4732	863	Melted butter and extra sugar	
4733	863	Anise seed	
4734	864	Fresh sweet corn kernels	
4735	864	Sweetened condensed milk	
4736	864	Unsalted butter	
4737	864	Large eggs	
4738	864	All-purpose flour and baking powder	
4739	864	Vanilla extract and salt	
4740	865	Long-grain white rice	
4741	865	Water and cinnamon stick	
4742	865	Whole milk	
4743	865	Sweetened condensed milk and evaporated milk	
4744	865	Lime or orange peel	
4745	865	Raisins	
4746	865	Ground cinnamon	
4747	866	All-purpose flour	
4748	866	Egg and whole milk	
4749	866	Sugar, vanilla extract, salt	
4750	866	Rosette iron mold	
4751	866	Vegetable oil	
4752	866	Cinnamon sugar mixture	
4753	867	Galletas Marías (crisp, round Mexican vanilla biscuits)	
4754	867	Sweetened condensed milk	
4755	867	Evaporated milk	
4756	867	Fresh lime juice	
4757	867	Lime zest	
4758	868	Sweet potatoes (camotes)	
4759	868	Piloncillo cones (unrefined Mexican cane sugar)	
4760	868	Cinnamon stick	
4761	868	Whole cloves and star anise	
4762	869	Shredded coconut	
4763	869	Sweetened condensed milk	
4764	869	Egg yolks	
4765	869	Vanilla extract and melted butter	
4766	870	Long-grain white rice	
4767	870	Raw almonds	
4768	870	Cinnamon stick	
4769	870	Whole milk or evaporated milk	
4770	870	Sweetened condensed milk or sugar	
4771	870	Cold water and ice cubes	
4772	871	Blanco or Reposado Tequila (100% blue agave)	
4773	871	Fresh lime juice	
4774	871	Triple Sec or Cointreau	
4775	871	Agave nectar or simple syrup	
4776	871	Coarse sea salt	
4777	871	Ice cubes and lime wheel	
4778	872	Masa Harina (finely ground corn flour)	
4779	872	Water or whole milk	
4780	872	Mexican chocolate disk	
4781	872	Piloncillo sugar or dark brown sugar	
4782	872	Cinnamon stick and anise seed	
4783	873	Dried hibiscus flowers (Flor de Jamaica)	
4784	873	Water	
4785	873	Sugar or simple syrup	
4786	873	Ice cubes	
4787	874	Mexican pale lager beer (Corona, Modelo, or Tecate)	
4788	874	Fresh lime juice	
4789	874	Worcestershire sauce and soy sauce (Maggi seasoning)	
4790	874	Mexican hot sauce (Valentina or Cholula)	
4791	874	Tajín chili-lime seasoning or coarse salt	
4792	874	Ice cubes and lime wedge	
4793	875	Dry black beans	
4794	875	Carne seca (Brazilian sun-dried beef)	
4795	875	Pork trimmings (ears, tail, trotters)	
4796	875	Smoked pork ribs and bacon	
4797	875	Paio sausage and Calabresa sausage	
4798	875	Onions and garlic	
4799	875	Bay leaves and cachaça	
4800	876	Firm white fish fillets	
4801	876	Large shrimp	
4802	876	Lime juice and minced garlic	
4803	876	Bell peppers (red, yellow, green)	
4804	876	Tomatoes and onions	
4805	876	Pure coconut milk	
4806	876	Azeite de dendê (red palm oil)	
4807	876	Fresh cilantro and green onions	
4808	877	Whole picanha roast (top sirloin cap)	
4809	877	Coarse sea salt (sal grosso)	
4810	878	Chicken breast	
4811	878	Catupiry cheese (or cream cheese)	
4812	878	All-purpose flour and chicken broth	
4813	878	Mashed potatoes	
4814	878	Onions, garlic, tomato paste	
4815	878	Beaten eggs and fine breadcrumbs	
4816	878	Vegetable oil	
4817	879	Beef chuck or brisket	
4818	879	Bacon	
4819	879	Onions and garlic	
4820	879	Ground cumin and bay leaves	
4821	879	Mandioca (cassava) flour and water	
4822	880	Mandioca (cassava/yuca root)	
4823	880	Large shrimp	
4824	880	Pure coconut milk	
4825	880	Azeite de dendê (red palm oil)	
4826	880	Onions, garlic, bell peppers	
4827	880	Fresh tomatoes	
4828	880	Fresh cilantro leaves	
4829	881	Long-grain white rice	
4830	881	Black-eyed peas	
4831	881	Carne de sol (sun-dried beef) or bacon	
4832	881	Queijo coalho (Brazilian grilling cheese)	
4833	881	Onions and garlic	
4834	881	Fresh cilantro and green onions	
4835	881	Clarified butter	
4836	882	Chicken thighs and drumsticks	
4837	882	Long-grain white rice	
4838	882	Pequi oil or whole pequi fruit	
4839	882	Onions, garlic, bell peppers	
4840	882	Corn kernels and diced tomatoes	
4841	882	Chicken broth	
4842	882	Fresh parsley and green onions	
4843	883	All-purpose flour and unsalted butter	
4844	883	Egg yolks and cold water	
4845	883	Shredded chicken breast	
4846	883	Onions, garlic, canned corn	
4847	883	Green olives and tomato sauce	
4848	883	Cream cheese or heavy cream	
4849	884	Stale French bread rolls	
4850	884	Dried shrimp and fresh shrimp	
4851	884	Peanuts and cashews	
4852	884	Onions, garlic, fresh ginger	
4853	884	Pure coconut milk	
4854	884	Azeite de dendê (red palm oil)	
4855	885	Sweetened condensed milk	
4856	885	Cocoa powder	
4857	885	Unsalted butter	
4858	885	Chocolate sprinkles	
4859	886	Egg yolks	
4860	886	Granulated white sugar	
4861	886	Fresh unsweetened grated coconut	
4862	886	Unsalted butter	
4863	887	Sweetened condensed milk	
4864	887	Whole milk	
4865	887	Whole eggs	
4866	887	Granulated sugar and water	
4867	888	Sweetened condensed milk	
4868	888	Grated coconut	
4869	888	Unsalted butter	
4870	888	Granulated sugar	
4871	888	Whole dried cloves	
4872	889	Queijo Minas (or Queso Fresco)	
4873	889	Goiabada (dense, sweet red guava paste block)	
4874	890	Unsalted butter	
4875	890	Granulated sugar and all-purpose flour	
4876	890	Eggs	
4877	890	Goiabada (guava paste) and water	
4878	890	Powdered sugar	
4879	891	Roasted, unsalted peanuts	
4880	891	Granulated sugar or icing sugar	
4881	891	Mandioca (cassava) flour or toasted corn flour	
4882	891	Sea salt	
4883	892	Sweetened condensed milk	
4884	892	Heavy whipping cream	
4885	892	Concentrated passion fruit juice	
4886	892	Fresh passion fruit pulp with seeds	
4887	892	Sugar and cornstarch	
4888	893	Fresh grated coconut	
4889	893	Sweetened condensed milk	
4890	893	Granulated sugar and water	
4891	893	Whole milk	
4892	893	Egg yolks	
4893	893	Cinnamon stick and whole cloves	
4894	894	Fresh sweet corn kernels	
4895	894	Whole milk	
4896	894	Granulated white sugar	
4897	894	Unsalted butter and salt	
4898	894	Ground cinnamon	
4899	895	Cachaça (Brazilian sugar cane spirit)	
4900	895	Fresh lime	
4901	895	Granulated white sugar	
4902	895	Crushed ice	
4903	896	Carbonated water	
4904	896	Guaraná extract powder or syrup	
4905	896	Simple syrup or cane sugar	
4906	896	Fresh lemon or lime slice	
4907	896	Ice cubes	
4908	897	Fresh sugar cane stalks	
4909	897	Fresh lime juice or pineapple juice	
4910	897	Ice cubes	
4911	898	Finely ground Brazilian coffee beans	
4912	898	Water	
4913	898	Granulated white sugar	
4914	899	Fresh ripe pineapple	
4915	899	Fresh mint leaves	
4916	899	Cold water	
4917	899	Sugar or honey	
4918	899	Ice cubes	
\.


--
-- Data for Name: recipe_folders; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY public.recipe_folders (id, user_id, folder_name, created_at) FROM stdin;
\.


--
-- Data for Name: recipes; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY public.recipes (id, dish_id, title, description, cuisine, region, category, prep_time, cook_time, difficulty, image_url, user_id, created_at) FROM stdin;
451	PH_M01	Adobo (chicken or pork)	A delicious Main Course from Philippines	Asians	Philippines	Main Course	15	30	Easy	\N	\N	2026-05-31 00:43:27.04721
452	PH_M02	Sinigang	A delicious Main Course from Philippines	Asians	Philippines	Main Course	15	30	Easy	\N	\N	2026-05-31 00:43:27.04721
453	PH_M03	Kare-Kare	A delicious Main Course from Philippines	Asians	Philippines	Main Course	15	30	Easy	\N	\N	2026-05-31 00:43:27.04721
454	PH_M04	Menudo	A delicious Main Course from Philippines	Asians	Philippines	Main Course	15	30	Easy	\N	\N	2026-05-31 00:43:27.04721
455	PH_M05	Caldereta	A delicious Main Course from Philippines	Asians	Philippines	Main Course	15	30	Easy	\N	\N	2026-05-31 00:43:27.04721
456	PH_M06	Tinola	A delicious Main Course from Philippines	Asians	Philippines	Main Course	15	30	Easy	\N	\N	2026-05-31 00:43:27.04721
457	PH_M07	Bicol Express	A delicious Main Course from Philippines	Asians	Philippines	Main Course	15	30	Easy	\N	\N	2026-05-31 00:43:27.04721
458	PH_M08	Beef Mechado	A delicious Main Course from Philippines	Asians	Philippines	Main Course	15	30	Easy	\N	\N	2026-05-31 00:43:27.04721
459	PH_M09	Dinuguan	A delicious Main Course from Philippines	Asians	Philippines	Main Course	15	30	Easy	\N	\N	2026-05-31 00:43:27.04721
460	PH_M10	Pinakbet	A delicious Main Course from Philippines	Asians	Philippines	Main Course	15	30	Easy	\N	\N	2026-05-31 00:43:27.04721
461	PH_D01	Halo-Halo	A delicious Dessert from Philippines	Asians	Philippines	Dessert	15	30	Easy	\N	\N	2026-05-31 00:43:27.04721
462	PH_D02	Leche Flan	A delicious Dessert from Philippines	Asians	Philippines	Dessert	15	30	Easy	\N	\N	2026-05-31 00:43:27.04721
463	PH_D03	Maja Blanca	A delicious Dessert from Philippines	Asians	Philippines	Dessert	15	30	Easy	\N	\N	2026-05-31 00:43:27.04721
464	PH_D04	Turon	A delicious Dessert from Philippines	Asians	Philippines	Dessert	15	30	Easy	\N	\N	2026-05-31 00:43:27.04721
465	PH_D05	Cassava Cake	A delicious Dessert from Philippines	Asians	Philippines	Dessert	15	30	Easy	\N	\N	2026-05-31 00:43:27.04721
466	PH_D06	Buko Pandan	A delicious Dessert from Philippines	Asians	Philippines	Dessert	15	30	Easy	\N	\N	2026-05-31 00:43:27.04721
467	PH_D07	Puto	A delicious Dessert from Philippines	Asians	Philippines	Dessert	15	30	Easy	\N	\N	2026-05-31 00:43:27.04721
468	PH_D08	Champorado	A delicious Dessert from Philippines	Asians	Philippines	Dessert	15	30	Easy	\N	\N	2026-05-31 00:43:27.04721
469	PH_D09	Kutsinta	A delicious Dessert from Philippines	Asians	Philippines	Dessert	15	30	Easy	\N	\N	2026-05-31 00:43:27.04721
470	PH_D10	Banana Cue	A delicious Dessert from Philippines	Asians	Philippines	Dessert	15	30	Easy	\N	\N	2026-05-31 00:43:27.04721
471	PH_B01	Sago't Gulaman	A delicious Beverage from Philippines	Asians	Philippines	Beverage	15	30	Easy	\N	\N	2026-05-31 00:43:27.04721
472	PH_B02	Buko Juice	A delicious Beverage from Philippines	Asians	Philippines	Beverage	15	30	Easy	\N	\N	2026-05-31 00:43:27.04721
473	PH_B03	Calamansi Juice	A delicious Beverage from Philippines	Asians	Philippines	Beverage	15	30	Easy	\N	\N	2026-05-31 00:43:27.04721
474	PH_B04	Melon Juice	A delicious Beverage from Philippines	Asians	Philippines	Beverage	15	30	Easy	\N	\N	2026-05-31 00:43:27.04721
475	PH_B05	Kapeng Barako	A delicious Beverage from Philippines	Asians	Philippines	Beverage	15	30	Easy	\N	\N	2026-05-31 00:43:27.04721
476	KR_M01	Kimchi Jjigae	A delicious Main Course from Korean	Asians	Korean	Main Course	15	30	Easy	\N	\N	2026-05-31 00:43:27.04721
477	KR_M02	Bulgogi	A delicious Main Course from Korean	Asians	Korean	Main Course	15	30	Easy	\N	\N	2026-05-31 00:43:27.04721
478	KR_M03	Bibimbap	A delicious Main Course from Korean	Asians	Korean	Main Course	15	30	Easy	\N	\N	2026-05-31 00:43:27.04721
479	KR_M04	Tteokbokki	A delicious Main Course from Korean	Asians	Korean	Main Course	15	30	Easy	\N	\N	2026-05-31 00:43:27.04721
480	KR_M05	Samgyetang	A delicious Main Course from Korean	Asians	Korean	Main Course	15	30	Easy	\N	\N	2026-05-31 00:43:27.04721
481	KR_M06	Jajangmyeon	A delicious Main Course from Korean	Asians	Korean	Main Course	15	30	Easy	\N	\N	2026-05-31 00:43:27.04721
482	KR_M07	Galbitang	A delicious Main Course from Korean	Asians	Korean	Main Course	15	30	Easy	\N	\N	2026-05-31 00:43:27.04721
483	KR_M08	Sundubu Jjigae	A delicious Main Course from Korean	Asians	Korean	Main Course	15	30	Easy	\N	\N	2026-05-31 00:43:27.04721
484	KR_M09	Japchae	A delicious Main Course from Korean	Asians	Korean	Main Course	15	30	Easy	\N	\N	2026-05-31 00:43:27.04721
485	KR_M10	Dakgalbi	A delicious Main Course from Korean	Asians	Korean	Main Course	15	30	Easy	\N	\N	2026-05-31 00:43:27.04721
486	KR_D01	Patbingsu	A delicious Dessert from Korean	Asians	Korean	Dessert	15	30	Easy	\N	\N	2026-05-31 00:43:27.04721
487	KR_D02	Hotteok	A delicious Dessert from Korean	Asians	Korean	Dessert	15	30	Easy	\N	\N	2026-05-31 00:43:27.04721
488	KR_D03	Yakgwa	A delicious Dessert from Korean	Asians	Korean	Dessert	15	30	Easy	\N	\N	2026-05-31 00:43:27.04721
489	KR_D04	Gyeongdan	A delicious Dessert from Korean	Asians	Korean	Dessert	15	30	Easy	\N	\N	2026-05-31 00:43:27.04721
490	KR_D05	Bungeoppang	A delicious Dessert from Korean	Asians	Korean	Dessert	15	30	Easy	\N	\N	2026-05-31 00:43:27.04721
491	KR_D06	Songpyeon	A delicious Dessert from Korean	Asians	Korean	Dessert	15	30	Easy	\N	\N	2026-05-31 00:43:27.04721
492	KR_D07	Hwajeon	A delicious Dessert from Korean	Asians	Korean	Dessert	15	30	Easy	\N	\N	2026-05-31 00:43:27.04721
493	KR_D08	Sikhye Granita	A delicious Dessert from Korean	Asians	Korean	Dessert	15	30	Easy	\N	\N	2026-05-31 00:43:27.04721
494	KR_D09	Chapssaltteok	A delicious Dessert from Korean	Asians	Korean	Dessert	15	30	Easy	\N	\N	2026-05-31 00:43:27.04721
495	KR_D10	Mat-tang	A delicious Dessert from Korean	Asians	Korean	Dessert	15	30	Easy	\N	\N	2026-05-31 00:43:27.04721
496	KR_B01	Sikhye	A delicious Beverage from Korean	Asians	Korean	Beverage	15	30	Easy	\N	\N	2026-05-31 00:43:27.04721
497	KR_B02	Sujeonggwa	A delicious Beverage from Korean	Asians	Korean	Beverage	15	30	Easy	\N	\N	2026-05-31 00:43:27.04721
498	KR_B03	Yuja-cha	A delicious Beverage from Korean	Asians	Korean	Beverage	15	30	Easy	\N	\N	2026-05-31 00:43:27.04721
499	KR_B04	Boricha	A delicious Beverage from Korean	Asians	Korean	Beverage	15	30	Easy	\N	\N	2026-05-31 00:43:27.04721
500	KR_B05	Misugaru Shake	A delicious Beverage from Korean	Asians	Korean	Beverage	15	30	Easy	\N	\N	2026-05-31 00:43:27.04721
501	JP_M01	Chicken Katsu Curry	A delicious Main Course from Japan	Asians	Japan	Main Course	15	30	Easy	\N	\N	2026-05-31 00:43:27.04721
502	JP_M02	Tonkotsu Ramen	A delicious Main Course from Japan	Asians	Japan	Main Course	15	30	Easy	\N	\N	2026-05-31 00:43:27.04721
503	JP_M03	Gyudon	A delicious Main Course from Japan	Asians	Japan	Main Course	15	30	Easy	\N	\N	2026-05-31 00:43:27.04721
504	JP_M04	Chicken Teriyaki	A delicious Main Course from Japan	Asians	Japan	Main Course	15	30	Easy	\N	\N	2026-05-31 00:43:27.04721
505	JP_M05	Tempura	A delicious Main Course from Japan	Asians	Japan	Main Course	15	30	Easy	\N	\N	2026-05-31 00:43:27.04721
506	JP_M06	Sukiyaki	A delicious Main Course from Japan	Asians	Japan	Main Course	15	30	Easy	\N	\N	2026-05-31 00:43:27.04721
507	JP_M07	Katsudon	A delicious Main Course from Japan	Asians	Japan	Main Course	15	30	Easy	\N	\N	2026-05-31 00:43:27.04721
508	JP_M08	Oyakodon	A delicious Main Course from Japan	Asians	Japan	Main Course	15	30	Easy	\N	\N	2026-05-31 00:43:27.04721
509	JP_M09	Yakisoba	A delicious Main Course from Japan	Asians	Japan	Main Course	15	30	Easy	\N	\N	2026-05-31 00:43:27.04721
510	JP_M10	Saba Shioyaki	A delicious Main Course from Japan	Asians	Japan	Main Course	15	30	Easy	\N	\N	2026-05-31 00:43:27.04721
511	JP_D01	Matcha Mochi	A delicious Dessert from Japan	Asians	Japan	Dessert	15	30	Easy	\N	\N	2026-05-31 00:43:27.04721
512	JP_D02	Dorayaki	A delicious Dessert from Japan	Asians	Japan	Dessert	15	30	Easy	\N	\N	2026-05-31 00:43:27.04721
513	JP_D03	Matcha Soft Serve Ice Cream	A delicious Dessert from Japan	Asians	Japan	Dessert	15	30	Easy	\N	\N	2026-05-31 00:43:27.04721
514	JP_D04	Castella Cake	A delicious Dessert from Japan	Asians	Japan	Dessert	15	30	Easy	\N	\N	2026-05-31 00:43:27.04721
515	JP_D05	Mitarashi Dango	A delicious Dessert from Japan	Asians	Japan	Dessert	15	30	Easy	\N	\N	2026-05-31 00:43:27.04721
516	JP_D06	Japanese Strawberry Shortcake	A delicious Dessert from Japan	Asians	Japan	Dessert	15	30	Easy	\N	\N	2026-05-31 00:43:27.04721
517	JP_D07	Taiyaki	A delicious Dessert from Japan	Asians	Japan	Dessert	15	30	Easy	\N	\N	2026-05-31 00:43:27.04721
518	JP_D08	Coffee Jelly	A delicious Dessert from Japan	Asians	Japan	Dessert	15	30	Easy	\N	\N	2026-05-31 00:43:27.04721
519	JP_D09	Anmitsu	A delicious Dessert from Japan	Asians	Japan	Dessert	15	30	Easy	\N	\N	2026-05-31 00:43:27.04721
520	JP_D10	Purin	A delicious Dessert from Japan	Asians	Japan	Dessert	15	30	Easy	\N	\N	2026-05-31 00:43:27.04721
521	JP_B01	Matcha Latte	A delicious Beverage from Japan	Asians	Japan	Beverage	15	30	Easy	\N	\N	2026-05-31 00:43:27.04721
522	JP_B02	Genmaicha	A delicious Beverage from Japan	Asians	Japan	Beverage	15	30	Easy	\N	\N	2026-05-31 00:43:27.04721
523	JP_B03	Hojicha	A delicious Beverage from Japan	Asians	Japan	Beverage	15	30	Easy	\N	\N	2026-05-31 00:43:27.04721
524	JP_B04	Ramune	A delicious Beverage from Japan	Asians	Japan	Beverage	15	30	Easy	\N	\N	2026-05-31 00:43:27.04721
525	JP_B05	Mugicha	A delicious Beverage from Japan	Asians	Japan	Beverage	15	30	Easy	\N	\N	2026-05-31 00:43:27.04721
526	CN_M01	Kung Pao Chicken	A delicious Main Course from China	Asians	China	Main Course	15	30	Easy	\N	\N	2026-05-31 00:43:27.04721
527	CN_M02	Mapo Tofu	A delicious Main Course from China	Asians	China	Main Course	15	30	Easy	\N	\N	2026-05-31 00:43:27.04721
528	CN_M03	Sweet and Sour Pork	A delicious Main Course from China	Asians	China	Main Course	15	30	Easy	\N	\N	2026-05-31 00:43:27.04721
529	CN_M04	Peking Duck	A delicious Main Course from China	Asians	China	Main Course	15	30	Easy	\N	\N	2026-05-31 00:43:27.04721
530	CN_M05	Beef and Broccoli	A delicious Main Course from China	Asians	China	Main Course	15	30	Easy	\N	\N	2026-05-31 00:43:27.04721
531	CN_M06	Wonton Noodle Soup	A delicious Main Course from China	Asians	China	Main Course	15	30	Easy	\N	\N	2026-05-31 00:43:27.04721
532	CN_M07	Yangzhou Fried Rice	A delicious Main Course from China	Asians	China	Main Course	15	30	Easy	\N	\N	2026-05-31 00:43:27.04721
533	CN_M08	Twice-Cooked Pork	A delicious Main Course from China	Asians	China	Main Course	15	30	Easy	\N	\N	2026-05-31 00:43:27.04721
534	CN_M09	Steamed Fish with Ginger and Scallions	A delicious Main Course from China	Asians	China	Main Course	15	30	Easy	\N	\N	2026-05-31 00:43:27.04721
535	CN_M10	Braised Pork Belly (Hong Shao Rou)	A delicious Main Course from China	Asians	China	Main Course	15	30	Easy	\N	\N	2026-05-31 00:43:27.04721
536	CN_D01	Egg Tarts	A delicious Dessert from China	Asians	China	Dessert	15	30	Easy	\N	\N	2026-05-31 00:43:27.04721
537	CN_D02	Sesame Balls (Jian Dui)	A delicious Dessert from China	Asians	China	Dessert	15	30	Easy	\N	\N	2026-05-31 00:43:27.04721
538	CN_D03	Mango Pomelo Sago	A delicious Dessert from China	Asians	China	Dessert	15	30	Easy	\N	\N	2026-05-31 00:43:27.04721
539	CN_D04	Red Bean Soup	A delicious Dessert from China	Asians	China	Dessert	15	30	Easy	\N	\N	2026-05-31 00:43:27.04721
540	CN_D05	Tangyuan (Glutinous Rice Balls)	A delicious Dessert from China	Asians	China	Dessert	15	30	Easy	\N	\N	2026-05-31 00:43:27.04721
541	CN_D06	Almond Tofu (Annin Tofu)	A delicious Dessert from China	Asians	China	Dessert	15	30	Easy	\N	\N	2026-05-31 00:43:27.04721
542	CN_D07	Fa Gao (Fortune Cake)	A delicious Dessert from China	Asians	China	Dessert	15	30	Easy	\N	\N	2026-05-31 00:43:27.04721
543	CN_D08	Deep-Fried Milk	A delicious Dessert from China	Asians	China	Dessert	15	30	Easy	\N	\N	2026-05-31 00:43:27.04721
544	CN_D09	Snowflake Crisps	A delicious Dessert from China	Asians	China	Dessert	15	30	Easy	\N	\N	2026-05-31 00:43:27.04721
545	CN_D10	Sweet Osmanthus Jelly	A delicious Dessert from China	Asians	China	Dessert	15	30	Easy	\N	\N	2026-05-31 00:43:27.04721
546	CN_B01	Pearl Milk Tea (Boba)	A delicious Beverage from China	Asians	China	Beverage	15	30	Easy	\N	\N	2026-05-31 00:43:27.04721
547	CN_B02	Chrysanthemum Tea	A delicious Beverage from China	Asians	China	Beverage	15	30	Easy	\N	\N	2026-05-31 00:43:27.04721
548	CN_B03	Plum Juice (Suanmeitang)	A delicious Beverage from China	Asians	China	Beverage	15	30	Easy	\N	\N	2026-05-31 00:43:27.04721
549	CN_B04	Cheese Tea	A delicious Beverage from China	Asians	China	Beverage	15	30	Easy	\N	\N	2026-05-31 00:43:27.04721
550	CN_B05	Soy Milk (Doujiang)	A delicious Beverage from China	Asians	China	Beverage	15	30	Easy	\N	\N	2026-05-31 00:43:27.04721
551	ID_M01	Nasi Goreng	A delicious Main Course from Indonesia	Asians	Indonesia	Main Course	15	30	Easy	\N	\N	2026-05-31 00:43:27.04721
552	ID_M02	Beef Rendang	A delicious Main Course from Indonesia	Asians	Indonesia	Main Course	15	30	Easy	\N	\N	2026-05-31 00:43:27.04721
553	ID_M03	Sate Ayam (Chicken Satay)	A delicious Main Course from Indonesia	Asians	Indonesia	Main Course	15	30	Easy	\N	\N	2026-05-31 00:43:27.04721
554	ID_M04	Gado-Gado	A delicious Main Course from Indonesia	Asians	Indonesia	Main Course	15	30	Easy	\N	\N	2026-05-31 00:43:27.04721
555	ID_M05	Ayam Goreng Laos	A delicious Main Course from Indonesia	Asians	Indonesia	Main Course	15	30	Easy	\N	\N	2026-05-31 00:43:27.04721
556	ID_M06	Bakso	A delicious Main Course from Indonesia	Asians	Indonesia	Main Course	15	30	Easy	\N	\N	2026-05-31 00:43:27.04721
557	ID_M07	Soto Ayam	A delicious Main Course from Indonesia	Asians	Indonesia	Main Course	15	30	Easy	\N	\N	2026-05-31 00:43:27.04721
558	ID_M08	Pepes Ikan	A delicious Main Course from Indonesia	Asians	Indonesia	Main Course	15	30	Easy	\N	\N	2026-05-31 00:43:27.04721
559	ID_M09	Cap Cay	A delicious Main Course from Indonesia	Asians	Indonesia	Main Course	15	30	Easy	\N	\N	2026-05-31 00:43:27.04721
560	ID_M10	Rawon	A delicious Main Course from Indonesia	Asians	Indonesia	Main Course	15	30	Easy	\N	\N	2026-05-31 00:43:27.04721
561	ID_D01	Es Teler	A delicious Dessert from Indonesia	Asians	Indonesia	Dessert	15	30	Easy	\N	\N	2026-05-31 00:43:27.04721
562	ID_D02	Martabak Manis	A delicious Dessert from Indonesia	Asians	Indonesia	Dessert	15	30	Easy	\N	\N	2026-05-31 00:43:27.04721
563	ID_D03	Klepon	A delicious Dessert from Indonesia	Asians	Indonesia	Dessert	15	30	Easy	\N	\N	2026-05-31 00:43:27.04721
564	ID_D04	Bubur Sumsum	A delicious Dessert from Indonesia	Asians	Indonesia	Dessert	15	30	Easy	\N	\N	2026-05-31 00:43:27.04721
565	ID_D05	Pisang Goreng	A delicious Dessert from Indonesia	Asians	Indonesia	Dessert	15	30	Easy	\N	\N	2026-05-31 00:43:27.04721
566	ID_D06	Dadar Gulung	A delicious Dessert from Indonesia	Asians	Indonesia	Dessert	15	30	Easy	\N	\N	2026-05-31 00:43:27.04721
567	ID_D07	Kolak Pisang	A delicious Dessert from Indonesia	Asians	Indonesia	Dessert	15	30	Easy	\N	\N	2026-05-31 00:43:27.04721
568	ID_D08	Lapis Legit (Spekkek)	A delicious Dessert from Indonesia	Asians	Indonesia	Dessert	15	30	Easy	\N	\N	2026-05-31 00:43:27.04721
569	ID_D09	Getuk	A delicious Dessert from Indonesia	Asians	Indonesia	Dessert	15	30	Easy	\N	\N	2026-05-31 00:43:27.04721
570	ID_D10	Nagasari	A delicious Dessert from Indonesia	Asians	Indonesia	Dessert	15	30	Easy	\N	\N	2026-05-31 00:43:27.04721
571	ID_B01	Es Cendol	A delicious Beverage from Indonesia	Asians	Indonesia	Beverage	15	30	Easy	\N	\N	2026-05-31 00:43:27.04721
572	ID_B02	Kopi Tubruk	A delicious Beverage from Indonesia	Asians	Indonesia	Beverage	15	30	Easy	\N	\N	2026-05-31 00:43:27.04721
573	ID_B03	Wedang Jahe	A delicious Beverage from Indonesia	Asians	Indonesia	Beverage	15	30	Easy	\N	\N	2026-05-31 00:43:27.04721
574	ID_B04	Es Kelapa Muda	A delicious Beverage from Indonesia	Asians	Indonesia	Beverage	15	30	Easy	\N	\N	2026-05-31 00:43:27.04721
575	ID_B05	Jus Alpukat	A delicious Beverage from Indonesia	Asians	Indonesia	Beverage	15	30	Easy	\N	\N	2026-05-31 00:43:27.04721
576	NG_M01	Jollof Rice	A delicious Main Course from Nigeria	African	Nigeria	Main Course	15	30	Easy	\N	\N	2026-05-31 00:43:27.04721
577	NG_M02	Egusi Soup with Pounded Yam	A delicious Main Course from Nigeria	African	Nigeria	Main Course	15	30	Easy	\N	\N	2026-05-31 00:43:27.04721
578	NG_M03	Suya	A delicious Main Course from Nigeria	African	Nigeria	Main Course	15	30	Easy	\N	\N	2026-05-31 00:43:27.04721
579	NG_M04	Pounded Yam and Ogbono Soup	A delicious Main Course from Nigeria	African	Nigeria	Main Course	15	30	Easy	\N	\N	2026-05-31 00:43:27.04721
580	NG_M05	Efo Riro	A delicious Main Course from Nigeria	African	Nigeria	Main Course	15	30	Easy	\N	\N	2026-05-31 00:43:27.04721
581	NG_M06	Pepper Soup	A delicious Main Course from Nigeria	African	Nigeria	Main Course	15	30	Easy	\N	\N	2026-05-31 00:43:27.04721
582	NG_M07	Amala and Abula	A delicious Main Course from Nigeria	African	Nigeria	Main Course	15	30	Easy	\N	\N	2026-05-31 00:43:27.04721
583	NG_M08	Tuwo Shinkafa with Miyan Taushe	A delicious Main Course from Nigeria	African	Nigeria	Main Course	15	30	Easy	\N	\N	2026-05-31 00:43:27.04721
584	NG_M09	Fried Rice (Nigerian Style)	A delicious Main Course from Nigeria	African	Nigeria	Main Course	15	30	Easy	\N	\N	2026-05-31 00:43:27.04721
585	NG_M10	Asun	A delicious Main Course from Nigeria	African	Nigeria	Main Course	15	30	Easy	\N	\N	2026-05-31 00:43:27.04721
586	NG_D01	Puff Puff	A delicious Dessert from Nigeria	African	Nigeria	Dessert	15	30	Easy	\N	\N	2026-05-31 00:43:27.04721
587	NG_D02	Chin Chin	A delicious Dessert from Nigeria	African	Nigeria	Dessert	15	30	Easy	\N	\N	2026-05-31 00:43:27.04721
588	NG_D03	Plantain Mosa	A delicious Dessert from Nigeria	African	Nigeria	Dessert	15	30	Easy	\N	\N	2026-05-31 00:43:27.04721
589	NG_D04	Coconut Candy	A delicious Dessert from Nigeria	African	Nigeria	Dessert	15	30	Easy	\N	\N	2026-05-31 00:43:27.04721
590	NG_D05	Shuku Shuku	A delicious Dessert from Nigeria	African	Nigeria	Dessert	15	30	Easy	\N	\N	2026-05-31 00:43:27.04721
591	NG_D06	Meat Pie (Sweet Pastry Style)	A delicious Dessert from Nigeria	African	Nigeria	Dessert	15	30	Easy	\N	\N	2026-05-31 00:43:27.04721
592	NG_D07	Kuli Kuli	A delicious Dessert from Nigeria	African	Nigeria	Dessert	15	30	Easy	\N	\N	2026-05-31 00:43:27.04721
593	NG_D08	Gurasa	A delicious Dessert from Nigeria	African	Nigeria	Dessert	15	30	Easy	\N	\N	2026-05-31 00:43:27.04721
594	NG_D09	Sweet Akara	A delicious Dessert from Nigeria	African	Nigeria	Dessert	15	30	Easy	\N	\N	2026-05-31 00:43:27.04721
595	NG_D10	Funnel Cakes (Nigerian Dundu Style)	A delicious Dessert from Nigeria	African	Nigeria	Dessert	15	30	Easy	\N	\N	2026-05-31 00:43:27.04721
596	NG_B01	Zobo Juice	A delicious Beverage from Nigeria	African	Nigeria	Beverage	15	30	Easy	\N	\N	2026-05-31 00:43:27.04721
597	NG_B02	Kunu Aya	A delicious Beverage from Nigeria	African	Nigeria	Beverage	15	30	Easy	\N	\N	2026-05-31 00:43:27.04721
598	NG_B03	Chapman	A delicious Beverage from Nigeria	African	Nigeria	Beverage	15	30	Easy	\N	\N	2026-05-31 00:43:27.04721
599	NG_B04	Kunu Zaki	A delicious Beverage from Nigeria	African	Nigeria	Beverage	15	30	Easy	\N	\N	2026-05-31 00:43:27.04721
600	NG_B05	Palm Wine (Mimbo)	A delicious Beverage from Nigeria	African	Nigeria	Beverage	15	30	Easy	\N	\N	2026-05-31 00:43:27.04721
601	ZA_M01	Bobotie	A delicious Main Course from South	African	South	Main Course	15	30	Easy	\N	\N	2026-05-31 00:43:27.04721
602	ZA_M02	Bunny Chow	A delicious Main Course from South	African	South	Main Course	15	30	Easy	\N	\N	2026-05-31 00:43:27.04721
603	ZA_M03	Boerewors	A delicious Main Course from South	African	South	Main Course	15	30	Easy	\N	\N	2026-05-31 00:43:27.04721
604	ZA_M04	Potjiekos	A delicious Main Course from South	African	South	Main Course	15	30	Easy	\N	\N	2026-05-31 00:43:27.04721
605	ZA_M05	Chakalaka with Pap	A delicious Main Course from South	African	South	Main Course	15	30	Easy	\N	\N	2026-05-31 00:43:27.04721
606	ZA_M06	Snoek Braai	A delicious Main Course from South	African	South	Main Course	15	30	Easy	\N	\N	2026-05-31 00:43:27.04721
607	ZA_M07	Tomato Bredie	A delicious Main Course from South	African	South	Main Course	15	30	Easy	\N	\N	2026-05-31 00:43:27.04721
608	ZA_M08	Vetkoek filled with Mince	A delicious Main Course from South	African	South	Main Course	15	30	Easy	\N	\N	2026-05-31 00:43:27.04721
609	ZA_M09	Denningvogel	A delicious Main Course from South	African	South	Main Course	15	30	Easy	\N	\N	2026-05-31 00:43:27.04721
610	ZA_M10	South African Yellow Rice	A delicious Main Course from South	African	South	Main Course	15	30	Easy	\N	\N	2026-05-31 00:43:27.04721
611	ZA_D01	Malva Pudding	A delicious Dessert from South	African	South	Dessert	15	30	Easy	\N	\N	2026-05-31 00:43:27.04721
612	ZA_D02	Melktert (Milk Tart)	A delicious Dessert from South	African	South	Dessert	15	30	Easy	\N	\N	2026-05-31 00:43:27.04721
613	ZA_D03	Koeksisters	A delicious Dessert from South	African	South	Dessert	15	30	Easy	\N	\N	2026-05-31 00:43:27.04721
614	ZA_D04	Peppermint Crisp Tert	A delicious Dessert from South	African	South	Dessert	15	30	Easy	\N	\N	2026-05-31 00:43:27.04721
615	ZA_D05	Hertzoggie	A delicious Dessert from South	African	South	Dessert	15	30	Easy	\N	\N	2026-05-31 00:43:27.04721
616	ZA_D06	Cape Brandy Pudding (Tipsy Tart)	A delicious Dessert from South	African	South	Dessert	15	30	Easy	\N	\N	2026-05-31 00:43:27.04721
617	ZA_D07	Soetkoekies	A delicious Dessert from South	African	South	Dessert	15	30	Easy	\N	\N	2026-05-31 00:43:27.04721
618	ZA_D08	Crunchies	A delicious Dessert from South	African	South	Dessert	15	30	Easy	\N	\N	2026-05-31 00:43:27.04721
619	ZA_D09	Mosbolletjies	A delicious Dessert from South	African	South	Dessert	15	30	Easy	\N	\N	2026-05-31 00:43:27.04721
620	ZA_D10	Rooibos Tea Jelly	A delicious Dessert from South	African	South	Dessert	15	30	Easy	\N	\N	2026-05-31 00:43:27.04721
621	ZA_B01	Rooibos Tea	A delicious Beverage from South	African	South	Beverage	15	30	Easy	\N	\N	2026-05-31 00:43:27.04721
622	ZA_B02	Dom Pedro	A delicious Beverage from South	African	South	Beverage	15	30	Easy	\N	\N	2026-05-31 00:43:27.04721
623	ZA_B03	Mageu	A delicious Beverage from South	African	South	Beverage	15	30	Easy	\N	\N	2026-05-31 00:43:27.04721
624	ZA_B04	Rock Spider	A delicious Beverage from South	African	South	Beverage	15	30	Easy	\N	\N	2026-05-31 00:43:27.04721
625	ZA_B05	Amahewu (Sorghum Drink)	A delicious Beverage from South	African	South	Beverage	15	30	Easy	\N	\N	2026-05-31 00:43:27.04721
626	EG_M01	Koshari	A delicious Main Course from Egypt	African	Egypt	Main Course	15	30	Easy	\N	\N	2026-05-31 00:43:27.04721
627	EG_M02	Molokhia with Chicken	A delicious Main Course from Egypt	African	Egypt	Main Course	15	30	Easy	\N	\N	2026-05-31 00:43:27.04721
628	EG_M03	Hamam Mahshi	A delicious Main Course from Egypt	African	Egypt	Main Course	15	30	Easy	\N	\N	2026-05-31 00:43:27.04721
629	EG_M04	Egyptian Fattah	A delicious Main Course from Egypt	African	Egypt	Main Course	15	30	Easy	\N	\N	2026-05-31 00:43:27.04721
630	EG_M05	Mahshi Morakkab (Assorted Stuffed Vegetables)	A delicious Main Course from Egypt	African	Egypt	Main Course	15	30	Easy	\N	\N	2026-05-31 00:43:27.04721
631	EG_M06	Hawawshi	A delicious Main Course from Egypt	African	Egypt	Main Course	15	30	Easy	\N	\N	2026-05-31 00:43:27.04721
632	EG_M07	Macaroni Béchamel	A delicious Main Course from Egypt	African	Egypt	Main Course	15	30	Easy	\N	\N	2026-05-31 00:43:27.04721
633	EG_M08	Bamia (Okra Stew)	A delicious Main Course from Egypt	African	Egypt	Main Course	15	30	Easy	\N	\N	2026-05-31 00:43:27.04721
634	EG_M09	Sayadieh Fish	A delicious Main Course from Egypt	African	Egypt	Main Course	15	30	Easy	\N	\N	2026-05-31 00:43:27.04721
635	EG_M10	Kebda Iskandarani (Alexandrian Liver)	A delicious Main Course from Egypt	African	Egypt	Main Course	15	30	Easy	\N	\N	2026-05-31 00:43:27.04721
636	EG_D01	Basbousa	A delicious Dessert from Egypt	African	Egypt	Dessert	15	30	Easy	\N	\N	2026-05-31 00:43:27.04721
637	EG_D02	Ali Om	A delicious Dessert from Egypt	African	Egypt	Dessert	15	30	Easy	\N	\N	2026-05-31 00:43:27.04721
638	EG_D03	Kunafa	A delicious Dessert from Egypt	African	Egypt	Dessert	15	30	Easy	\N	\N	2026-05-31 00:43:27.04721
639	EG_D04	Atayef	A delicious Dessert from Egypt	African	Egypt	Dessert	15	30	Easy	\N	\N	2026-05-31 00:43:27.04721
640	EG_D05	Roz Bel Laban (Egyptian Rice Pudding)	A delicious Dessert from Egypt	African	Egypt	Dessert	15	30	Easy	\N	\N	2026-05-31 00:43:27.04721
641	EG_D06	Zalabia (Luqaimat)	A delicious Dessert from Egypt	African	Egypt	Dessert	15	30	Easy	\N	\N	2026-05-31 00:43:27.04721
642	EG_D07	Meshallal (Egyptian Feteer)	A delicious Dessert from Egypt	African	Egypt	Dessert	15	30	Easy	\N	\N	2026-05-31 00:43:27.04721
643	EG_D08	Ghorayeba	A delicious Dessert from Egypt	African	Egypt	Dessert	15	30	Easy	\N	\N	2026-05-31 00:43:27.04721
644	EG_D09	Kahk	A delicious Dessert from Egypt	African	Egypt	Dessert	15	30	Easy	\N	\N	2026-05-31 00:43:27.04721
645	EG_D10	Mehalabya	A delicious Dessert from Egypt	African	Egypt	Dessert	15	30	Easy	\N	\N	2026-05-31 00:43:27.04721
646	EG_B01	Karkadeh (Hibiscus Tea)	A delicious Beverage from Egypt	African	Egypt	Beverage	15	30	Easy	\N	\N	2026-05-31 00:43:27.04721
647	EG_B02	Egyptian Shay Mint (Mint Tea)	A delicious Beverage from Egypt	African	Egypt	Beverage	15	30	Easy	\N	\N	2026-05-31 00:43:27.04721
648	EG_B03	Sahlab	A delicious Beverage from Egypt	African	Egypt	Beverage	15	30	Easy	\N	\N	2026-05-31 00:43:27.04721
649	EG_B04	Sobia	A delicious Beverage from Egypt	African	Egypt	Beverage	15	30	Easy	\N	\N	2026-05-31 00:43:27.04721
650	EG_B05	Asab (Sugarcane Juice)	A delicious Beverage from Egypt	African	Egypt	Beverage	15	30	Easy	\N	\N	2026-05-31 00:43:27.04721
651	AU_M01	Chicken Parmigiana (The "Parma")	A delicious Main Course from Australia	Oceania	Australia	Main Course	15	30	Easy	\N	\N	2026-05-31 00:43:27.04721
652	AU_M02	Aussie Meat Pie	A delicious Main Course from Australia	Oceania	Australia	Main Course	15	30	Easy	\N	\N	2026-05-31 00:43:27.04721
653	AU_M03	Barramundi with Lemon Myrtle	A delicious Main Course from Australia	Oceania	Australia	Main Course	15	30	Easy	\N	\N	2026-05-31 00:43:27.04721
654	AU_M04	Lamb Roast with Mint Sauce	A delicious Main Course from Australia	Oceania	Australia	Main Course	15	30	Easy	\N	\N	2026-05-31 00:43:27.04721
655	AU_M05	Kangaroo Fillet with Wattleseed Rub	A delicious Main Course from Australia	Oceania	Australia	Main Course	15	30	Easy	\N	\N	2026-05-31 00:43:27.04721
656	AU_M06	Sausage Sizzle	A delicious Main Course from Australia	Oceania	Australia	Main Course	15	30	Easy	\N	\N	2026-05-31 00:43:27.04721
657	AU_M07	Carpetbag Steak	A delicious Main Course from Australia	Oceania	Australia	Main Course	15	30	Easy	\N	\N	2026-05-31 00:43:27.04721
658	AU_M08	Salt and Pepper Squid	A delicious Main Course from Australia	Oceania	Australia	Main Course	15	30	Easy	\N	\N	2026-05-31 00:43:27.04721
659	AU_M09	Pumpkin Soup with Billy Bread	A delicious Main Course from Australia	Oceania	Australia	Main Course	15	30	Easy	\N	\N	2026-05-31 00:43:27.04721
660	AU_M10	Meatballs in BBQ Plum Sauce	A delicious Main Course from Australia	Oceania	Australia	Main Course	15	30	Easy	\N	\N	2026-05-31 00:43:27.04721
661	AU_D01	Pavlova	A delicious Dessert from Australia	Oceania	Australia	Dessert	15	30	Easy	\N	\N	2026-05-31 00:43:27.04721
662	AU_D02	Lamingtons	A delicious Dessert from Australia	Oceania	Australia	Dessert	15	30	Easy	\N	\N	2026-05-31 00:43:27.04721
663	AU_D03	Anzac Biscuits	A delicious Dessert from Australia	Oceania	Australia	Dessert	15	30	Easy	\N	\N	2026-05-31 00:43:27.04721
664	AU_D04	Golden Syrup Dumplings	A delicious Dessert from Australia	Oceania	Australia	Dessert	15	30	Easy	\N	\N	2026-05-31 00:43:27.04721
665	AU_D05	Vanilla Slice	A delicious Dessert from Australia	Oceania	Australia	Dessert	15	30	Easy	\N	\N	2026-05-31 00:43:27.04721
666	AU_D06	Iced Vovo Tart	A delicious Dessert from Australia	Oceania	Australia	Dessert	15	30	Easy	\N	\N	2026-05-31 00:43:27.04721
667	AU_D07	Quandong Peach Pie	A delicious Dessert from Australia	Oceania	Australia	Dessert	15	30	Easy	\N	\N	2026-05-31 00:43:27.04721
668	AU_D08	Chocolate Crackles	A delicious Dessert from Australia	Oceania	Australia	Dessert	15	30	Easy	\N	\N	2026-05-31 00:43:27.04721
669	AU_D09	Honeycomb Cannelloni	A delicious Dessert from Australia	Oceania	Australia	Dessert	15	30	Easy	\N	\N	2026-05-31 00:43:27.04721
670	AU_D10	Jelly Slice	A delicious Dessert from Australia	Oceania	Australia	Dessert	15	30	Easy	\N	\N	2026-05-31 00:43:27.04721
671	AU_B01	Flat White	A delicious Beverage from Australia	Oceania	Australia	Beverage	15	30	Easy	\N	\N	2026-05-31 00:43:27.04721
672	AU_B02	Lemon, Lime and Bitters (LLB)	A delicious Beverage from Australia	Oceania	Australia	Beverage	15	30	Easy	\N	\N	2026-05-31 00:43:27.04721
673	AU_B03	Billy Tea	A delicious Beverage from Australia	Oceania	Australia	Beverage	15	30	Easy	\N	\N	2026-05-31 00:43:27.04721
674	AU_B04	Milo Dinosaur (Aussie Style)	A delicious Beverage from Australia	Oceania	Australia	Beverage	15	30	Easy	\N	\N	2026-05-31 00:43:27.04721
675	AU_B05	Ginger Beer	A delicious Beverage from Australia	Oceania	Australia	Beverage	15	30	Easy	\N	\N	2026-05-31 00:43:27.04721
676	NZ_M01	Traditional Māori Hāngī	A delicious Main Course from New	Oceania	New	Main Course	15	30	Easy	\N	\N	2026-05-31 00:43:27.04721
677	NZ_M02	New Zealand Roast Lamb	A delicious Main Course from New	Oceania	New	Main Course	15	30	Easy	\N	\N	2026-05-31 00:43:27.04721
678	NZ_M03	Mince and Cheese Pie	A delicious Main Course from New	Oceania	New	Main Course	15	30	Easy	\N	\N	2026-05-31 00:43:27.04721
679	NZ_M04	Whitebait Fritters	A delicious Main Course from New	Oceania	New	Main Course	15	30	Easy	\N	\N	2026-05-31 00:43:27.04721
680	NZ_M05	Creamy Green-Lipped Mussels	A delicious Main Course from New	Oceania	New	Main Course	15	30	Easy	\N	\N	2026-05-31 00:43:27.04721
681	NZ_M06	Māori Boil Up	A delicious Main Course from New	Oceania	New	Main Course	15	30	Easy	\N	\N	2026-05-31 00:43:27.04721
682	NZ_M07	Southland Cheese Rolls ("Kiwi Sushi")	A delicious Main Course from New	Oceania	New	Main Course	15	30	Easy	\N	\N	2026-05-31 00:43:27.04721
683	NZ_M08	Bacon and Egg Pie	A delicious Main Course from New	Oceania	New	Main Course	15	30	Easy	\N	\N	2026-05-31 00:43:27.04721
684	NZ_M09	Colonial Goose	A delicious Main Course from New	Oceania	New	Main Course	15	30	Easy	\N	\N	2026-05-31 00:43:27.04721
685	NZ_M10	Paua Fritters	A delicious Main Course from New	Oceania	New	Main Course	15	30	Easy	\N	\N	2026-05-31 00:43:27.04721
686	NZ_D01	New Zealand Pavlova	A delicious Dessert from New	Oceania	New	Dessert	15	30	Easy	\N	\N	2026-05-31 00:43:27.04721
687	NZ_D02	Lolly Cake	A delicious Dessert from New	Oceania	New	Dessert	15	30	Easy	\N	\N	2026-05-31 00:43:27.04721
688	NZ_D03	Hokey Pokey Ice Cream	A delicious Dessert from New	Oceania	New	Dessert	15	30	Easy	\N	\N	2026-05-31 00:43:27.04721
689	NZ_D04	Ginger Crunch	A delicious Dessert from New	Oceania	New	Dessert	15	30	Easy	\N	\N	2026-05-31 00:43:27.04721
690	NZ_D05	Louise Cake	A delicious Dessert from New	Oceania	New	Dessert	15	30	Easy	\N	\N	2026-05-31 00:43:27.04721
691	NZ_D06	Afghan Biscuits	A delicious Dessert from New	Oceania	New	Dessert	15	30	Easy	\N	\N	2026-05-31 00:43:27.04721
692	NZ_D07	Feijoa Crumble	A delicious Dessert from New	Oceania	New	Dessert	15	30	Easy	\N	\N	2026-05-31 00:43:27.04721
693	NZ_D08	New Zealand Custard Square	A delicious Dessert from New	Oceania	New	Dessert	15	30	Easy	\N	\N	2026-05-31 00:43:27.04721
694	NZ_D09	Brandy Snaps	A delicious Dessert from New	Oceania	New	Dessert	15	30	Easy	\N	\N	2026-05-31 00:43:27.04721
695	NZ_D10	Chelsea Winter Buns	A delicious Dessert from New	Oceania	New	Dessert	15	30	Easy	\N	\N	2026-05-31 00:43:27.04721
696	NZ_B01	Lemon & Paeroa (L&P)	A delicious Beverage from New	Oceania	New	Beverage	15	30	Easy	\N	\N	2026-05-31 00:43:27.04721
697	NZ_B02	The Kiwi Flat White	A delicious Beverage from New	Oceania	New	Beverage	15	30	Easy	\N	\N	2026-05-31 00:43:27.04721
698	NZ_B03	Feijoa Mojito	A delicious Beverage from New	Oceania	New	Beverage	15	30	Easy	\N	\N	2026-05-31 00:43:27.04721
699	NZ_B04	Kawakawa Herbal Tea	A delicious Beverage from New	Oceania	New	Beverage	15	30	Easy	\N	\N	2026-05-31 00:43:27.04721
700	NZ_B05	Hokey Pokey Shake	A delicious Beverage from New	Oceania	New	Beverage	15	30	Easy	\N	\N	2026-05-31 00:43:27.04721
701	FJ_M01	Fiji Kokoda	A delicious Main Course from Fiji	Oceania	Fiji	Main Course	15	30	Easy	\N	\N	2026-05-31 00:43:27.04721
702	FJ_M02	Lovo Chicken and Pork	A delicious Main Course from Fiji	Oceania	Fiji	Main Course	15	30	Easy	\N	\N	2026-05-31 00:43:27.04721
703	FJ_M03	Rourou	A delicious Main Course from Fiji	Oceania	Fiji	Main Course	15	30	Easy	\N	\N	2026-05-31 00:43:27.04721
704	FJ_M04	Fish Suruwa	A delicious Main Course from Fiji	Oceania	Fiji	Main Course	15	30	Easy	\N	\N	2026-05-31 00:43:27.04721
705	FJ_M05	Cassava Vakakalolo	A delicious Main Course from Fiji	Oceania	Fiji	Main Course	15	30	Easy	\N	\N	2026-05-31 00:43:27.04721
706	FJ_M06	Curried Octopus (Kakana Dina)	A delicious Main Course from Fiji	Oceania	Fiji	Main Course	15	30	Easy	\N	\N	2026-05-31 00:43:27.04721
707	FJ_M07	Baigan Valo	A delicious Main Course from Fiji	Oceania	Fiji	Main Course	15	30	Easy	\N	\N	2026-05-31 00:43:27.04721
708	FJ_M08	Fiji Lamb Chop Curry	A delicious Main Course from Fiji	Oceania	Fiji	Main Course	15	30	Easy	\N	\N	2026-05-31 00:43:27.04721
709	FJ_M09	Ika Vakalolo	A delicious Main Course from Fiji	Oceania	Fiji	Main Course	15	30	Easy	\N	\N	2026-05-31 00:43:27.04721
710	FJ_M10	Palusami	A delicious Main Course from Fiji	Oceania	Fiji	Main Course	15	30	Easy	\N	\N	2026-05-31 00:43:27.04721
711	FJ_D01	Vakalolo	A delicious Dessert from Fiji	Oceania	Fiji	Dessert	15	30	Easy	\N	\N	2026-05-31 00:43:27.04721
712	FJ_D02	Purini	A delicious Dessert from Fiji	Oceania	Fiji	Dessert	15	30	Easy	\N	\N	2026-05-31 00:43:27.04721
713	FJ_D03	Babakau	A delicious Dessert from Fiji	Oceania	Fiji	Dessert	15	30	Easy	\N	\N	2026-05-31 00:43:27.04721
714	FJ_D05	Lolo Buns	A delicious Dessert from Fiji	Oceania	Fiji	Dessert	15	30	Easy	\N	\N	2026-05-31 00:43:27.04721
715	FJ_D06	Fiji Banana Fritters	A delicious Dessert from Fiji	Oceania	Fiji	Dessert	15	30	Easy	\N	\N	2026-05-31 00:43:27.04721
716	FJ_D07	Tavioka Vakakalolo	A delicious Dessert from Fiji	Oceania	Fiji	Dessert	15	30	Easy	\N	\N	2026-05-31 00:43:27.04721
717	FJ_D08	Coconut Macaroons (Island Style)	A delicious Dessert from Fiji	Oceania	Fiji	Dessert	15	30	Easy	\N	\N	2026-05-31 00:43:27.04721
718	FJ_D09	Topoi	A delicious Dessert from Fiji	Oceania	Fiji	Dessert	15	30	Easy	\N	\N	2026-05-31 00:43:27.04721
719	FJ_D10	Custard Pie (Fiji Style)	A delicious Dessert from Fiji	Oceania	Fiji	Dessert	15	30	Easy	\N	\N	2026-05-31 00:43:27.04721
720	FJ_B01	Kava (Yaqona)	A delicious Beverage from Fiji	Oceania	Fiji	Beverage	15	30	Easy	\N	\N	2026-05-31 00:43:27.04721
721	FJ_B02	Fiji Bush Tea (Draunividi)	A delicious Beverage from Fiji	Oceania	Fiji	Beverage	15	30	Easy	\N	\N	2026-05-31 00:43:27.04721
722	FJ_B03	Waicalo (Coconut Water with Flesh)	A delicious Beverage from Fiji	Oceania	Fiji	Beverage	15	30	Easy	\N	\N	2026-05-31 00:43:27.04721
723	FJ_B04	Fiji Gold Shandy	A delicious Beverage from Fiji	Oceania	Fiji	Beverage	15	30	Easy	\N	\N	2026-05-31 00:43:27.04721
724	FJ_B05	Pineapple Lemongrass Cooler	A delicious Beverage from Fiji	Oceania	Fiji	Beverage	15	30	Easy	\N	\N	2026-05-31 00:43:27.04721
725	FR_M01	Coq au Vin	A delicious Main Course from France	Europe	France	Main Course	15	30	Easy	\N	\N	2026-05-31 00:43:27.04721
726	FR_M02	Boeuf Bourguignon	A delicious Main Course from France	Europe	France	Main Course	15	30	Easy	\N	\N	2026-05-31 00:43:27.04721
727	FR_M03	Ratatouille	A delicious Main Course from France	Europe	France	Main Course	15	30	Easy	\N	\N	2026-05-31 00:43:27.04721
728	FR_M04	Duck Confit (Confit de Canard)	A delicious Main Course from France	Europe	France	Main Course	15	30	Easy	\N	\N	2026-05-31 00:43:27.04721
729	FR_M05	Sole Meunière	A delicious Main Course from France	Europe	France	Main Course	15	30	Easy	\N	\N	2026-05-31 00:43:27.04721
730	FR_M06	Quiche Lorraine	A delicious Main Course from France	Europe	France	Main Course	15	30	Easy	\N	\N	2026-05-31 00:43:27.04721
731	FR_M07	Bouillabaisse	A delicious Main Course from France	Europe	France	Main Course	15	30	Easy	\N	\N	2026-05-31 00:43:27.04721
732	FR_M08	Cassoulet	A delicious Main Course from France	Europe	France	Main Course	15	30	Easy	\N	\N	2026-05-31 00:43:27.04721
733	FR_M09	Croque Monsieur	A delicious Main Course from France	Europe	France	Main Course	15	30	Easy	\N	\N	2026-05-31 00:43:27.04721
734	FR_M10	Steak Frites	A delicious Main Course from France	Europe	France	Main Course	15	30	Easy	\N	\N	2026-05-31 00:43:27.04721
735	FR_D01	Crème Brûlée	A delicious Dessert from France	Europe	France	Dessert	15	30	Easy	\N	\N	2026-05-31 00:43:27.04721
736	FR_D02	Tarte Tatin	A delicious Dessert from France	Europe	France	Dessert	15	30	Easy	\N	\N	2026-05-31 00:43:27.04721
737	FR_D03	Macarons	A delicious Dessert from France	Europe	France	Dessert	15	30	Easy	\N	\N	2026-05-31 00:43:27.04721
738	FR_D04	Profiteroles	A delicious Dessert from France	Europe	France	Dessert	15	30	Easy	\N	\N	2026-05-31 00:43:27.04721
739	FR_D05	Éclairs	A delicious Dessert from France	Europe	France	Dessert	15	30	Easy	\N	\N	2026-05-31 00:43:27.04721
740	FR_D06	Madeleines	A delicious Dessert from France	Europe	France	Dessert	15	30	Easy	\N	\N	2026-05-31 00:43:27.04721
741	FR_D07	Soufflé au Chocolat	A delicious Dessert from France	Europe	France	Dessert	15	30	Easy	\N	\N	2026-05-31 00:43:27.04721
742	FR_D08	Mille-Feuille (Napoleon)	A delicious Dessert from France	Europe	France	Dessert	15	30	Easy	\N	\N	2026-05-31 00:43:27.04721
743	FR_D09	Mille Crêpes Cake	A delicious Dessert from France	Europe	France	Dessert	15	30	Easy	\N	\N	2026-05-31 00:43:27.04721
744	FR_D10	Paris-Brest	A delicious Dessert from France	Europe	France	Dessert	15	30	Easy	\N	\N	2026-05-31 00:43:27.04721
745	FR_B01	French Press Coffee (Café en Cafetière)	A delicious Beverage from France	Europe	France	Beverage	15	30	Easy	\N	\N	2026-05-31 00:43:27.04721
746	FR_B02	Chocolat Chaud à l'Ancienne (French Hot Chocolate)	A delicious Beverage from France	Europe	France	Beverage	15	30	Easy	\N	\N	2026-05-31 00:43:27.04721
747	FR_B03	Kir Royale	A delicious Beverage from France	Europe	France	Beverage	15	30	Easy	\N	\N	2026-05-31 00:43:27.04721
748	FR_B04	Citronnade	A delicious Beverage from France	Europe	France	Beverage	15	30	Easy	\N	\N	2026-05-31 00:43:27.04721
749	FR_B05	Café au Lait	A delicious Beverage from France	Europe	France	Beverage	15	30	Easy	\N	\N	2026-05-31 00:43:27.04721
750	DE_M01	Sauerbraten	A delicious Main Course from Germany	Europe	Germany	Main Course	15	30	Easy	\N	\N	2026-05-31 00:43:27.04721
751	DE_M02	Wiener Schnitzel (German Style)	A delicious Main Course from Germany	Europe	Germany	Main Course	15	30	Easy	\N	\N	2026-05-31 00:43:27.04721
752	DE_M03	Rouladen	A delicious Main Course from Germany	Europe	Germany	Main Course	15	30	Easy	\N	\N	2026-05-31 00:43:27.04721
753	DE_M04	Käsespätzle	A delicious Main Course from Germany	Europe	Germany	Main Course	15	30	Easy	\N	\N	2026-05-31 00:43:27.04721
754	DE_M05	Königsberger Klopse	A delicious Main Course from Germany	Europe	Germany	Main Course	15	30	Easy	\N	\N	2026-05-31 00:43:27.04721
755	DE_M06	Currywurst	A delicious Main Course from Germany	Europe	Germany	Main Course	15	30	Easy	\N	\N	2026-05-31 00:43:27.04721
756	DE_M07	Schweinshaxe	A delicious Main Course from Germany	Europe	Germany	Main Course	15	30	Easy	\N	\N	2026-05-31 00:43:27.04721
757	DE_M08	Eisbein	A delicious Main Course from Germany	Europe	Germany	Main Course	15	30	Easy	\N	\N	2026-05-31 00:43:27.04721
758	DE_M09	Maultaschen	A delicious Main Course from Germany	Europe	Germany	Main Course	15	30	Easy	\N	\N	2026-05-31 00:43:27.04721
759	DE_M10	Leberkäse	A delicious Main Course from Germany	Europe	Germany	Main Course	15	30	Easy	\N	\N	2026-05-31 00:43:27.04721
760	DE_D01	Apfelstrudel (German Apple Strudel)	A delicious Dessert from Germany	Europe	Germany	Dessert	15	30	Easy	\N	\N	2026-05-31 00:43:27.04721
761	DE_D02	Schwarzwälder Kirschtorte (Black Forest Cake)	A delicious Dessert from Germany	Europe	Germany	Dessert	15	30	Easy	\N	\N	2026-05-31 00:43:27.04721
762	DE_D03	Rote Grütze	A delicious Dessert from Germany	Europe	Germany	Dessert	15	30	Easy	\N	\N	2026-05-31 00:43:27.04721
763	DE_D04	Käsekuchen (German Cheesecake)	A delicious Dessert from Germany	Europe	Germany	Dessert	15	30	Easy	\N	\N	2026-05-31 00:43:27.04721
764	DE_D05	Spaghettieis	A delicious Dessert from Germany	Europe	Germany	Dessert	15	30	Easy	\N	\N	2026-05-31 00:43:27.04721
765	DE_D06	Bienenstich (Bee Sting Cake)	A delicious Dessert from Germany	Europe	Germany	Dessert	15	30	Easy	\N	\N	2026-05-31 00:43:27.04721
766	DE_D07	Dampfnudeln	A delicious Dessert from Germany	Europe	Germany	Dessert	15	30	Easy	\N	\N	2026-05-31 00:43:27.04721
767	DE_D08	Kaiserschmarrn	A delicious Dessert from Germany	Europe	Germany	Dessert	15	30	Easy	\N	\N	2026-05-31 00:43:27.04721
768	DE_D09	Berliner Pfannkuchen	A delicious Dessert from Germany	Europe	Germany	Dessert	15	30	Easy	\N	\N	2026-05-31 00:43:27.04721
769	DE_D10	Zimtsterne (Cinnamon Stars)	A delicious Dessert from Germany	Europe	Germany	Dessert	15	30	Easy	\N	\N	2026-05-31 00:43:27.04721
770	DE_B01	Spezi (Mezzo Mix Style)	A delicious Beverage from Germany	Europe	Germany	Beverage	15	30	Easy	\N	\N	2026-05-31 00:43:27.04721
771	DE_B02	Apfelschorle	A delicious Beverage from Germany	Europe	Germany	Beverage	15	30	Easy	\N	\N	2026-05-31 00:43:27.04721
772	DE_B03	Glühwein	A delicious Beverage from Germany	Europe	Germany	Beverage	15	30	Easy	\N	\N	2026-05-31 00:43:27.04721
773	DE_B04	Radler	A delicious Beverage from Germany	Europe	Germany	Beverage	15	30	Easy	\N	\N	2026-05-31 00:43:27.04721
774	DE_B05	Eiskaffee	A delicious Beverage from Germany	Europe	Germany	Beverage	15	30	Easy	\N	\N	2026-05-31 00:43:27.04721
775	IT_M01	Tagliatelle alla Bolognese	A delicious Main Course from Italy	Europe	Italy	Main Course	15	30	Easy	\N	\N	2026-05-31 00:43:27.04721
776	IT_M02	Risotto alla Milanese	A delicious Main Course from Italy	Europe	Italy	Main Course	15	30	Easy	\N	\N	2026-05-31 00:43:27.04721
777	IT_M03	Ossobuco alla Milanese	A delicious Main Course from Italy	Europe	Italy	Main Course	15	30	Easy	\N	\N	2026-05-31 00:43:27.04721
778	IT_M04	Gnocchi alla Sorrentina	A delicious Main Course from Italy	Europe	Italy	Main Course	15	30	Easy	\N	\N	2026-05-31 00:43:27.04721
779	IT_M05	Pollo alla Cacciatore	A delicious Main Course from Italy	Europe	Italy	Main Course	15	30	Easy	\N	\N	2026-05-31 00:43:27.04721
780	IT_M06	Melanzane alla Parmigiana	A delicious Main Course from Italy	Europe	Italy	Main Course	15	30	Easy	\N	\N	2026-05-31 00:43:27.04721
781	IT_M07	Spaghetti alle Vongole	A delicious Main Course from Italy	Europe	Italy	Main Course	15	30	Easy	\N	\N	2026-05-31 00:43:27.04721
782	IT_M08	Saltimbocca alla Romana	A delicious Main Course from Italy	Europe	Italy	Main Course	15	30	Easy	\N	\N	2026-05-31 00:43:27.04721
783	IT_M09	Bistecca alla Fiorentina	A delicious Main Course from Italy	Europe	Italy	Main Course	15	30	Easy	\N	\N	2026-05-31 00:43:27.04721
784	IT_M10	Porchetta	A delicious Main Course from Italy	Europe	Italy	Main Course	15	30	Easy	\N	\N	2026-05-31 00:43:27.04721
785	IT_D01	Tiramisù	A delicious Dessert from Italy	Europe	Italy	Dessert	15	30	Easy	\N	\N	2026-05-31 00:43:27.04721
786	IT_D02	Panna Cotta	A delicious Dessert from Italy	Europe	Italy	Dessert	15	30	Easy	\N	\N	2026-05-31 00:43:27.04721
787	IT_D03	Cannoli Siciliani	A delicious Dessert from Italy	Europe	Italy	Dessert	15	30	Easy	\N	\N	2026-05-31 00:43:27.04721
788	IT_D04	Torta Caprese	A delicious Dessert from Italy	Europe	Italy	Dessert	15	30	Easy	\N	\N	2026-05-31 00:43:27.04721
789	IT_D05	Gelato al Pistacchio	A delicious Dessert from Italy	Europe	Italy	Dessert	15	30	Easy	\N	\N	2026-05-31 00:43:27.04721
790	IT_D06	Affogato al Caffè	A delicious Dessert from Italy	Europe	Italy	Dessert	15	30	Easy	\N	\N	2026-05-31 00:43:27.04721
791	IT_D07	Cantucci con Vin Santo	A delicious Dessert from Italy	Europe	Italy	Dessert	15	30	Easy	\N	\N	2026-05-31 00:43:27.04721
792	IT_D08	Granita di Caffè con Panna	A delicious Dessert from Italy	Europe	Italy	Dessert	15	30	Easy	\N	\N	2026-05-31 00:43:27.04721
793	IT_D09	Crostata alla Confettura	A delicious Dessert from Italy	Europe	Italy	Dessert	15	30	Easy	\N	\N	2026-05-31 00:43:27.04721
794	IT_D10	Panettone	A delicious Dessert from Italy	Europe	Italy	Dessert	15	30	Easy	\N	\N	2026-05-31 00:43:27.04721
795	IT_B01	Espresso Italiano	A delicious Beverage from Italy	Europe	Italy	Beverage	15	30	Easy	\N	\N	2026-05-31 00:43:27.04721
796	IT_B02	Aperol Spritz	A delicious Beverage from Italy	Europe	Italy	Beverage	15	30	Easy	\N	\N	2026-05-31 00:43:27.04721
797	IT_B03	Limoncello	A delicious Beverage from Italy	Europe	Italy	Beverage	15	30	Easy	\N	\N	2026-05-31 00:43:27.04721
798	IT_B04	Negroni	A delicious Beverage from Italy	Europe	Italy	Beverage	15	30	Easy	\N	\N	2026-05-31 00:43:27.04721
799	IT_B05	Chinotto	A delicious Beverage from Italy	Europe	Italy	Beverage	15	30	Easy	\N	\N	2026-05-31 00:43:27.04721
800	CA_M01	Paella Valenciana	A delicious Main Course from Canada	North America	Canada	Main Course	15	30	Easy	\N	\N	2026-05-31 00:43:27.04721
801	CA_M02	Tortilla Española (Spanish Omelet)	A delicious Main Course from Canada	North America	Canada	Main Course	15	30	Easy	\N	\N	2026-05-31 00:43:27.04721
802	CA_M03	Gambas al Ajillo	A delicious Main Course from Canada	North America	Canada	Main Course	15	30	Easy	\N	\N	2026-05-31 00:43:27.04721
803	CA_M04	Cocido Madrileño	A delicious Main Course from Canada	North America	Canada	Main Course	15	30	Easy	\N	\N	2026-05-31 00:43:27.04721
804	CA_M05	Pulpo a la Gallega (Polbo á Feira)	A delicious Main Course from Canada	North America	Canada	Main Course	15	30	Easy	\N	\N	2026-05-31 00:43:27.04721
805	CA_M06	Cordero Asado (Roast Lamb)	A delicious Main Course from Canada	North America	Canada	Main Course	15	30	Easy	\N	\N	2026-05-31 00:43:27.04721
806	CA_M07	Gazpacho Andaluz	A delicious Main Course from Canada	North America	Canada	Main Course	15	30	Easy	\N	\N	2026-05-31 00:43:27.04721
807	CA_M08	Fabada Asturiana	A delicious Main Course from Canada	North America	Canada	Main Course	15	30	Easy	\N	\N	2026-05-31 00:43:27.04721
808	CA_M09	Carrilladas de Cerdo (Braised Pork Cheeks)	A delicious Main Course from Canada	North America	Canada	Main Course	15	30	Easy	\N	\N	2026-05-31 00:43:27.04721
809	CA_M10	Bacalao al Pil-Pil	A delicious Main Course from Canada	North America	Canada	Main Course	15	30	Easy	\N	\N	2026-05-31 00:43:27.04721
810	CA_D01	Churros con Chocolate	A delicious Dessert from Canada	North America	Canada	Dessert	15	30	Easy	\N	\N	2026-05-31 00:43:27.04721
811	CA_D02	Crema Catalana	A delicious Dessert from Canada	North America	Canada	Dessert	15	30	Easy	\N	\N	2026-05-31 00:43:27.04721
812	CA_D03	Tarta de Santiago	A delicious Dessert from Canada	North America	Canada	Dessert	15	30	Easy	\N	\N	2026-05-31 00:43:27.04721
813	CA_D04	Torrijas	A delicious Dessert from Canada	North America	Canada	Dessert	15	30	Easy	\N	\N	2026-05-31 00:43:27.04721
814	CA_D05	Tarta de Queso de San Sebastián	A delicious Dessert from Canada	North America	Canada	Dessert	15	30	Easy	\N	\N	2026-05-31 00:43:27.04721
815	CA_D06	Quesada Pasiega	A delicious Dessert from Canada	North America	Canada	Dessert	15	30	Easy	\N	\N	2026-05-31 00:43:27.04721
816	CA_D07	Polvorones	A delicious Dessert from Canada	North America	Canada	Dessert	15	30	Easy	\N	\N	2026-05-31 00:43:27.04721
817	CA_D08	Leche Frita (Fried Milk)	A delicious Dessert from Canada	North America	Canada	Dessert	15	30	Easy	\N	\N	2026-05-31 00:43:27.04721
818	CA_D09	Tocino de Cielo	A delicious Dessert from Canada	North America	Canada	Dessert	15	30	Easy	\N	\N	2026-05-31 00:43:27.04721
819	CA_D10	Ensaimada Mallorquina	A delicious Dessert from Canada	North America	Canada	Dessert	15	30	Easy	\N	\N	2026-05-31 00:43:27.04721
820	CA_B01	Sangría	A delicious Beverage from Canada	North America	Canada	Beverage	15	30	Easy	\N	\N	2026-05-31 00:43:27.04721
821	CA_B02	Café Bombón	A delicious Beverage from Canada	North America	Canada	Beverage	15	30	Easy	\N	\N	2026-05-31 00:43:27.04721
822	CA_B03	Tinto de Verano	A delicious Beverage from Canada	North America	Canada	Beverage	15	30	Easy	\N	\N	2026-05-31 00:43:27.04721
823	CA_B04	Horchata de Chufa	A delicious Beverage from Canada	North America	Canada	Beverage	15	30	Easy	\N	\N	2026-05-31 00:43:27.04721
824	CA_B05	Clara de Limón	A delicious Beverage from Canada	North America	Canada	Beverage	15	30	Easy	\N	\N	2026-05-31 00:43:27.04721
825	US_M01	Texas Smoked Brisket	A delicious Main Course from United	North America	United	Main Course	15	30	Easy	\N	\N	2026-05-31 00:43:27.04721
826	US_M02	Southern Fried Chicken	A delicious Main Course from United	North America	United	Main Course	15	30	Easy	\N	\N	2026-05-31 00:43:27.04721
827	US_M03	Maryland Crab Cakes	A delicious Main Course from United	North America	United	Main Course	15	30	Easy	\N	\N	2026-05-31 00:43:27.04721
828	US_M04	New England Clam Chowder	A delicious Main Course from United	North America	United	Main Course	15	30	Easy	\N	\N	2026-05-31 00:43:27.04721
829	US_M05	Classic Buffalo Wings	A delicious Main Course from United	North America	United	Main Course	15	30	Easy	\N	\N	2026-05-31 00:43:27.04721
830	US_M06	Jambalaya	A delicious Main Course from United	North America	United	Main Course	15	30	Easy	\N	\N	2026-05-31 00:43:27.04721
831	US_M07	Philly Cheesesteak	A delicious Main Course from United	North America	United	Main Course	15	30	Easy	\N	\N	2026-05-31 00:43:27.04721
832	US_M08	Chicago Deep-Dish Pizza	A delicious Main Course from United	North America	United	Main Course	15	30	Easy	\N	\N	2026-05-31 00:43:27.04721
833	US_M09	Shrimp and Grits	A delicious Main Course from United	North America	United	Main Course	15	30	Easy	\N	\N	2026-05-31 00:43:27.04721
834	US_M10	Meatloaf	A delicious Main Course from United	North America	United	Main Course	15	30	Easy	\N	\N	2026-05-31 00:43:27.04721
835	US_D01	New York Cheesecake	A delicious Dessert from United	North America	United	Dessert	15	30	Easy	\N	\N	2026-05-31 00:43:27.04721
836	US_D02	Apple Pie	A delicious Dessert from United	North America	United	Dessert	15	30	Easy	\N	\N	2026-05-31 00:43:27.04721
837	US_D03	Fudgy Chocolate Brownies	A delicious Dessert from United	North America	United	Dessert	15	30	Easy	\N	\N	2026-05-31 00:43:27.04721
838	US_D04	Chocolate Chip Cookies	A delicious Dessert from United	North America	United	Dessert	15	30	Easy	\N	\N	2026-05-31 00:43:27.04721
839	US_D05	Key Lime Pie	A delicious Dessert from United	North America	United	Dessert	15	30	Easy	\N	\N	2026-05-31 00:43:27.04721
840	US_D06	Southern Pecan Pie	A delicious Dessert from United	North America	United	Dessert	15	30	Easy	\N	\N	2026-05-31 00:43:27.04721
841	US_D07	Peach Cobbler	A delicious Dessert from United	North America	United	Dessert	15	30	Easy	\N	\N	2026-05-31 00:43:27.04721
842	US_D08	Red Velvet Cake	A delicious Dessert from United	North America	United	Dessert	15	30	Easy	\N	\N	2026-05-31 00:43:27.04721
843	US_D09	Banana Pudding	A delicious Dessert from United	North America	United	Dessert	15	30	Easy	\N	\N	2026-05-31 00:43:27.04721
844	US_D10	Mississippi Mud Pie	A delicious Dessert from United	North America	United	Dessert	15	30	Easy	\N	\N	2026-05-31 00:43:27.04721
845	US_B01	Sweet Tea	A delicious Beverage from United	North America	United	Beverage	15	30	Easy	\N	\N	2026-05-31 00:43:27.04721
846	US_B02	Old Fashioned	A delicious Beverage from United	North America	United	Beverage	15	30	Easy	\N	\N	2026-05-31 00:43:27.04721
847	US_B03	Root Beer Float	A delicious Beverage from United	North America	United	Beverage	15	30	Easy	\N	\N	2026-05-31 00:43:27.04721
848	US_B04	Mint Julep	A delicious Beverage from United	North America	United	Beverage	15	30	Easy	\N	\N	2026-05-31 00:43:27.04721
849	US_B05	Apple Cider (Spiced Hot Style)	A delicious Beverage from United	North America	United	Beverage	15	30	Easy	\N	\N	2026-05-31 00:43:27.04721
850	MX_M01	Mole Poblano	A delicious Main Course from Mexico	North America	Mexico	Main Course	15	30	Easy	\N	\N	2026-05-31 00:43:27.04721
851	MX_M02	Tacos al Pastor	A delicious Main Course from Mexico	North America	Mexico	Main Course	15	30	Easy	\N	\N	2026-05-31 00:43:27.04721
852	MX_M03	Chiles en Nogada	A delicious Main Course from Mexico	North America	Mexico	Main Course	15	30	Easy	\N	\N	2026-05-31 00:43:27.04721
853	MX_M04	Pozole Rojo	A delicious Main Course from Mexico	North America	Mexico	Main Course	15	30	Easy	\N	\N	2026-05-31 00:43:27.04721
854	MX_M05	Carnitas	A delicious Main Course from Mexico	North America	Mexico	Main Course	15	30	Easy	\N	\N	2026-05-31 00:43:27.04721
855	MX_M06	Cochinita Pibil	A delicious Main Course from Mexico	North America	Mexico	Main Course	15	30	Easy	\N	\N	2026-05-31 00:43:27.04721
856	MX_M07	Enchiladas Verdes	A delicious Main Course from Mexico	North America	Mexico	Main Course	15	30	Easy	\N	\N	2026-05-31 00:43:27.04721
857	MX_M08	Birria de Res	A delicious Main Course from Mexico	North America	Mexico	Main Course	15	30	Easy	\N	\N	2026-05-31 00:43:27.04721
858	MX_M09	Chilaquiles Rojos	A delicious Main Course from Mexico	North America	Mexico	Main Course	15	30	Easy	\N	\N	2026-05-31 00:43:27.04721
859	MX_M10	Aguachile Verde	A delicious Main Course from Mexico	North America	Mexico	Main Course	15	30	Easy	\N	\N	2026-05-31 00:43:27.04721
860	MX_D01	Flan Parisino (Mexican Flan)	A delicious Dessert from Mexico	North America	Mexico	Dessert	15	30	Easy	\N	\N	2026-05-31 00:43:27.04721
861	MX_D02	Tres Leches Cake	A delicious Dessert from Mexico	North America	Mexico	Dessert	15	30	Easy	\N	\N	2026-05-31 00:43:27.04721
862	MX_D03	Churros de Cajeta	A delicious Dessert from Mexico	North America	Mexico	Dessert	15	30	Easy	\N	\N	2026-05-31 00:43:27.04721
863	MX_D04	Pan de Muerto	A delicious Dessert from Mexico	North America	Mexico	Dessert	15	30	Easy	\N	\N	2026-05-31 00:43:27.04721
864	MX_D05	Pastel de Elote	A delicious Dessert from Mexico	North America	Mexico	Dessert	15	30	Easy	\N	\N	2026-05-31 00:43:27.04721
865	MX_D06	Arroz con Leche	A delicious Dessert from Mexico	North America	Mexico	Dessert	15	30	Easy	\N	\N	2026-05-31 00:43:27.04721
866	MX_D07	Buñuelos de Viento	A delicious Dessert from Mexico	North America	Mexico	Dessert	15	30	Easy	\N	\N	2026-05-31 00:43:27.04721
867	MX_D08	Carlota de Limón	A delicious Dessert from Mexico	North America	Mexico	Dessert	15	30	Easy	\N	\N	2026-05-31 00:43:27.04721
868	MX_D09	Camotes Enmielados	A delicious Dessert from Mexico	North America	Mexico	Dessert	15	30	Easy	\N	\N	2026-05-31 00:43:27.04721
869	MX_D10	Cocadas	A delicious Dessert from Mexico	North America	Mexico	Dessert	15	30	Easy	\N	\N	2026-05-31 00:43:27.04721
870	MX_B01	Horchata de Arroz	A delicious Beverage from Mexico	North America	Mexico	Beverage	15	30	Easy	\N	\N	2026-05-31 00:43:27.04721
871	MX_B02	Margarita	A delicious Beverage from Mexico	North America	Mexico	Beverage	15	30	Easy	\N	\N	2026-05-31 00:43:27.04721
872	MX_B03	Champurrado	A delicious Beverage from Mexico	North America	Mexico	Beverage	15	30	Easy	\N	\N	2026-05-31 00:43:27.04721
873	MX_B04	Agua de Jamaica	A delicious Beverage from Mexico	North America	Mexico	Beverage	15	30	Easy	\N	\N	2026-05-31 00:43:27.04721
874	MX_B05	Michelada	A delicious Beverage from Mexico	North America	Mexico	Beverage	15	30	Easy	\N	\N	2026-05-31 00:43:27.04721
875	BR_M01	Feijoada	A delicious Main Course from Brazil	South America	Brazil	Main Course	15	30	Easy	\N	\N	2026-05-31 00:43:27.04721
876	BR_M02	Moqueca Baiana	A delicious Main Course from Brazil	South America	Brazil	Main Course	15	30	Easy	\N	\N	2026-05-31 00:43:27.04721
877	BR_M03	Picanha al Forno (or Grelhada)	A delicious Main Course from Brazil	South America	Brazil	Main Course	15	30	Easy	\N	\N	2026-05-31 00:43:27.04721
878	BR_M04	Coxinha de Frango	A delicious Main Course from Brazil	South America	Brazil	Main Course	15	30	Easy	\N	\N	2026-05-31 00:43:27.04721
879	BR_M05	Barreado	A delicious Main Course from Brazil	South America	Brazil	Main Course	15	30	Easy	\N	\N	2026-05-31 00:43:27.04721
880	BR_M06	Bobó de Camarão	A delicious Main Course from Brazil	South America	Brazil	Main Course	15	30	Easy	\N	\N	2026-05-31 00:43:27.04721
881	BR_M07	Baião de Dois	A delicious Main Course from Brazil	South America	Brazil	Main Course	15	30	Easy	\N	\N	2026-05-31 00:43:27.04721
882	BR_M08	Galinhada	A delicious Main Course from Brazil	South America	Brazil	Main Course	15	30	Easy	\N	\N	2026-05-31 00:43:27.04721
883	BR_M09	Empadão de Frango	A delicious Main Course from Brazil	South America	Brazil	Main Course	15	30	Easy	\N	\N	2026-05-31 00:43:27.04721
884	BR_M10	Vatapá	A delicious Main Course from Brazil	South America	Brazil	Main Course	15	30	Easy	\N	\N	2026-05-31 00:43:27.04721
885	BR_D01	Brigadeiro	A delicious Dessert from Brazil	South America	Brazil	Dessert	15	30	Easy	\N	\N	2026-05-31 00:43:27.04721
886	BR_D02	Quindim	A delicious Dessert from Brazil	South America	Brazil	Dessert	15	30	Easy	\N	\N	2026-05-31 00:43:27.04721
887	BR_D03	Pudim de Leite Condensado	A delicious Dessert from Brazil	South America	Brazil	Dessert	15	30	Easy	\N	\N	2026-05-31 00:43:27.04721
888	BR_D04	Beijinho de Coco	A delicious Dessert from Brazil	South America	Brazil	Dessert	15	30	Easy	\N	\N	2026-05-31 00:43:27.04721
889	BR_D05	Romeu e Julieta	A delicious Dessert from Brazil	South America	Brazil	Dessert	15	30	Easy	\N	\N	2026-05-31 00:43:27.04721
890	BR_D06	Bolo de Rolo	A delicious Dessert from Brazil	South America	Brazil	Dessert	15	30	Easy	\N	\N	2026-05-31 00:43:27.04721
891	BR_D07	Paçoca de Amendoim	A delicious Dessert from Brazil	South America	Brazil	Dessert	15	30	Easy	\N	\N	2026-05-31 00:43:27.04721
892	BR_D08	Mousse de Maracujá	A delicious Dessert from Brazil	South America	Brazil	Dessert	15	30	Easy	\N	\N	2026-05-31 00:43:27.04721
893	BR_D09	Cocada Cremosa	A delicious Dessert from Brazil	South America	Brazil	Dessert	15	30	Easy	\N	\N	2026-05-31 00:43:27.04721
894	BR_D10	Curau de Milho	A delicious Dessert from Brazil	South America	Brazil	Dessert	15	30	Easy	\N	\N	2026-05-31 00:43:27.04721
895	BR_B01	Caipirinha	A delicious Beverage from Brazil	South America	Brazil	Beverage	15	30	Easy	\N	\N	2026-05-31 00:43:27.04721
896	BR_B02	Guaraná Antarctica (Style Soda)	A delicious Beverage from Brazil	South America	Brazil	Beverage	15	30	Easy	\N	\N	2026-05-31 00:43:27.04721
897	BR_B03	Caldo de Cana	A delicious Beverage from Brazil	South America	Brazil	Beverage	15	30	Easy	\N	\N	2026-05-31 00:43:27.04721
898	BR_B04	Cafézinho	A delicious Beverage from Brazil	South America	Brazil	Beverage	15	30	Easy	\N	\N	2026-05-31 00:43:27.04721
899	BR_B05	Suco de Abacaxi com Hortelã	A delicious Beverage from Brazil	South America	Brazil	Beverage	15	30	Easy	\N	\N	2026-05-31 00:43:27.04721
\.


--
-- Data for Name: shopping_list; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY public.shopping_list (id, user_id, ingredient_name, quantity, checked, recipe_id, added_at) FROM stdin;
\.


--
-- Data for Name: steps; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY public.steps (id, recipe_id, step_number, instruction) FROM stdin;
3084	451	1	Marinate the meat in soy sauce and garlic.|2. Cook the meat in a pan.|3. Add vinegar, water, bay leaves, and pepper.|4. Simmer until the meat becomes tender.|5. Serve with rice.
3085	452	1	Boil water with tomatoes and onion.|2. Add the meat or seafood.|3. Put the sinigang mix for sour flavor.|4. Add vegetables and cook until soft.|5. Serve hot.
3086	453	1	Boil the meat until tender.|2. Sauté garlic and onion.|3. Add peanut butter and water.|4. Put the cooked meat into the sauce.|5. Add the vegetables and cook until tender.|6. Serve with bagoong and rice.
3087	454	1	Sauté garlic and onion in a pan.|2. Add pork and cook until brown.|3. Add tomato sauce and soy sauce.|4. Put potatoes and carrots.|5. Simmer until the meat becomes tender.|6. Add liver and cook for a few minutes.|7. Serve hot with rice.
3088	455	1	Sauté garlic and onion.|2. Add the meat and cook until brown.|3. Pour tomato sauce and water.|4. Simmer until the meat is tender.|5. Add vegetables and liver spread.|6. Cook for a few more minutes.|7. Serve with rice.
3089	456	1	Sauté garlic, onion, and ginger.|2. Add chicken and cook lightly.|3. Pour water and let it boil.|4. Simmer until the chicken becomes tender.|5. Add green papaya and chili leaves.|6. Season with fish sauce.|7. Serve hot.
3090	457	1	Sauté garlic, onion, and ginger in a pan.|2. Add the shrimp paste and cook for a minute.|3. Add the pork cubes and cook until they turn light brown.|4. Pour in the coconut milk and bring to a simmer.|5. Add the chopped chilies and let it cook down until the pork is tender.|6. Pour in the coconut cream to thicken the sauce and render oil.|7. Serve hot with plenty of rice.
3091	458	1	Marinate beef in soy sauce and calamansi juice for 30 minutes.|2. Sauté garlic and onions, then add the beef and sear.|3. Pour in the tomato sauce, marinade, and beef broth, then bring to a boil.|4. Simmer until the beef becomes tender.|5. Add the potatoes and carrots, cooking until soft.|6. Toss in the bell peppers and simmer for another 2 minutes.|7. Serve hot.
3092	459	1	Sauté garlic, onion, and ginger in a pot.|2. Add the pork pieces and cook until lightly browned.|3. Pour in fish sauce and a bit of broth, then simmer until the pork is tender.|4. Add vinegar and let it boil without stirring.|5. Slowly pour in the pig's blood while stirring constantly to prevent clumping.|6. Add green chilies and simmer until the sauce thickens.|7. Serve hot, ideally with puto (steamed rice cakes).
3093	460	1	Sauté garlic, onion, and tomatoes in a pot.|2. Add pork belly and cook until fat renders.|3. Stir in the shrimp paste and cook for 2 minutes.|4. Add water and bring to a boil, then throw in the squash first until slightly soft.|5. Add the remaining vegetables (bitter melon, eggplant, okra, string beans).|6. Cover and simmer until all vegetables are tender but still crisp.|7. Serve hot.
3094	461	1	In a tall glass, layer the sweetened fruits, beans, and jellies at the bottom.|2. Fill the glass with shaved ice.|3. Pour evaporated milk generously over the ice.|4. Top with a slice of leche flan, a dollop of ube halaya, and a scoop of ube ice cream.|5. Serve immediately with a long spoon to mix everything together.
3095	462	1	Place sugar directly into aluminum molds (llaneras) and heat over a low flame until it melts into a golden caramel. Let it cool.|2. In a bowl, gently blend the egg yolks, condensed milk, evaporated milk, and vanilla extract without creating too many bubbles.|3. Strain the mixture through a fine mesh cloth into the caramelized molds.|4. Cover the molds tightly with aluminum foil.|5. Steam for about 30 to 35 minutes until the custard sets.|6. Let it cool, refrigerate, then flip onto a plate to serve.
3096	463	1	Combine coconut milk, condensed milk, evaporated milk, sugar, and sweet corn in a pot over medium heat.|2. Dissolve cornstarch in a small portion of water or milk, then stir it into the pot.|3. Stir continuously until the mixture thickens into a heavy paste.|4. Pour the hot mixture into a greased serving dish and smooth out the top.|5. Let it cool down and chill in the refrigerator until completely firm.|6. Garnish with latik or toasted coconut before slicing and serving.
3097	464	1	Roll each banana slice generously in brown sugar.|2. Place a sugar-coated banana slice and a strip of jackfruit onto a spring roll wrapper.|3. Fold the sides in and roll tightly, securing the edge with a dab of water.|4. Heat oil in a pan and sprinkle a few tablespoons of brown sugar directly into the hot oil.|5. Fry the wrapped bananas, rolling them in the melting caramel until the wrapper is crispy and glazed.|6. Drain excess oil and serve warm.
3098	465	1	Combine grated cassava, coconut milk, condensed milk, evaporated milk, sugar, and egg whites in a large bowl.|2. Pour the mixture into a greased baking pan.|3. Bake in a preheated oven at 180°C (350°F) for about 45 minutes until almost firm.|4. Prepare the topping by mixing condensed milk, coconut milk, and egg yolks.|5. Pour the topping over the cake, sprinkle with grated cheese, and bake for another 15 minutes until golden brown.|6. Cool completely before slicing.
3099	466	1	Prepare the pandan gelatin according to package instructions, let it set, and cut into cubes.|2. In a large mixing bowl, combine the all-purpose cream and condensed milk.|3. Add the shredded young coconut, gelatin cubes, and cooked tapioca pearls.|4. Mix thoroughly until well incorporated.|5. Chill in the refrigerator for at least 4 hours or overnight.|6. Serve chilled.
3100	467	1	Sift flour, baking powder, and sugar together in a bowl.|2. Gradually stir in the water or milk and melted butter until smooth.|3. Pour the batter into small greased molds until 3/4 full.|4. Arrange the molds in a steamer.|5. Steam for about 10 minutes, then place a small piece of cheese on top of each cake.|6. Steam for another 2 minutes until the cheese melts.|7. Remove from molds and serve warm.
3101	468	1	Boil water in a pot and add the glutinous rice.|2. Lower the heat and let the rice simmer, stirring occasionally to prevent sticking, until soft.|3. Dissolve the chocolate tablea or cocoa powder into the rice mixture.|4. Add sugar to taste and stir until fully dissolved and the mixture thickens.|5. Ladle into bowls.|6. Drizzle with evaporated or condensed milk before serving.
3102	469	1	In a bowl, mix all-purpose flour, rice flour, and brown sugar.|2. Gradually whisk in water and annatto water until free of lumps.|3. Add the lye water and blend thoroughly.|4. Strain the mixture into greased molds.|5. Steam for 40 to 45 minutes until the cakes become translucent and set.|6. Allow to cool completely before removing from the molds.|7. Serve topped with fresh grated coconut.
3103	470	1	Heat oil in a large pan over medium heat.|2. Add the brown sugar directly into the hot oil and let it melt and float.|3. Add the bananas into the pan and fry them.|4. Adjust the heat and turn the bananas continuously so the melting sugar coats them evenly.|5. Once the bananas are cooked through and fully glazed, remove them from the oil.|6. Skew two to three bananas onto each bamboo stick.|7. Allow to cool slightly so the sugar hardens before serving.
3104	471	1	Boil brown sugar and water together to create a thick sugar syrup (arnibal).|2. Remove from heat and add a drop of vanilla extract for aroma, then let it cool.|3. In a large pitcher, combine water, the prepared sugar syrup, and stir well.|4. Add the cooked tapioca pearls and gelatin cubes.|5. Add crushed ice into glasses.|6. Pour the mixture over the ice and serve cold.
3105	472	1	Crack open a fresh young coconut and pour the water into a pitcher.|2. Scrape out the soft coconut meat using a shredder or spoon and add it to the water.|3. Taste the juice and stir in sugar or a touch of condensed milk if you prefer it sweeter.|4. Mix thoroughly until the sweetener dissolves.|5. Add ice cubes to chill.|6. Serve chilled in glasses.
3106	473	1	Slice the top off the calamansi fruits.|2. Squeeze the juice through a fine strainer into a pitcher to catch the seeds.|3. Add water to dilute the strong sour taste.|4. Stir in sugar or honey according to your preferred sweetness.|5. Mix well until the sweetener completely dissolves.|6. Add ice cubes and serve ice-cold.
3107	474	1	Slice the melon in half, scrape out the seeds, and discard them.|2. Use a melon scraper to shred the melon flesh into thin strands.|3. Place the shredded melon and its natural juices into a pitcher.|4. Add water and sugar, stirring until the sugar dissolves.|5. Pour in a splash of evaporated milk if you want a creamy texture.|6. Serve cold over ice.
3108	475	1	Boil water in a pot or coffee maker.|2. Add the ground Barako coffee beans directly to the boiling water if using the traditional boiling method.|3. Let it simmer on low heat for about 3 to 5 minutes to extract the full flavor.|4. Turn off the heat and let the coffee grounds settle at the bottom of the pot.|5. Strain the coffee liquid into a cup.|6. Serve hot as black coffee, or stir in brown sugar to taste.
3109	476	1	Sauté the pork and garlic in a pot until the pork is lightly browned.|2. Add the aged kimchi and stir-fry with the pork for a few minutes.|3. Pour in the water or kelp broth and bring to a boil.|4. Stir in the gochugaru and gochujang, then lower the heat to a simmer.|5. Let it simmer until the kimchi becomes very soft and tender.|6. Add the tofu slices and green onions, cooking for another 5 minutes.|7. Serve bubbling hot with steamed rice.
3110	477	1	Mix soy sauce, sugar, grated pear, garlic, ginger, and sesame oil in a bowl.|2. Add the beef slices to the marinade, mixing well to coat each piece.|3. Marinate in the refrigerator for at least 30 minutes.|4. Heat a pan or grill over high heat.|5. Stir-fry the beef quickly along with chopped green onions until cooked through.|6. Garnish with toasted sesame seeds.|7. Serve hot, optionally wrapped in lettuce leaves.
3111	478	1	Sauté each vegetable separately with a bit of garlic, sesame oil, and salt.|2. Cook the beef in a pan with soy sauce and garlic until browned.|3. Fry an egg, keeping the yolk runny.|4. Place a generous scoop of warm rice at the bottom of a bowl.|5. Arrange the seasoned vegetables and meat neatly in sections on top of the rice.|6. Place the fried egg in the center.|7. Serve with a dollop of gochujang and a drizzle of sesame oil to mix before eating.
3112	479	1	Bring the anchovy and kelp broth to a boil in a shallow pan.|2. Whisk in the gochujang, gochugaru, sugar, soy sauce, and garlic until dissolved.|3. Add the rice cakes and sliced fish cakes into the boiling sauce.|4. Reduce heat to medium and stir continuously so the rice cakes don't stick.|5. Simmer until the sauce thickens and the rice cakes become soft and chewy.|6. Toss in the chopped green onions during the last minute.|7. Serve hot.
3113	480	1	Wash the chicken thoroughly and stuff the cavity with the soaked glutinous rice, garlic cloves, and ginseng.|2. Cross the chicken's legs and tie them to keep the stuffing inside.|3. Place the stuffed chicken in a large pot with water, jujubes, and ginger.|4. Bring to a boil over high heat, skimming off any foam that rises.|5. Cover, reduce heat to medium-low, and simmer for about an hour until the chicken is tender.|6. Garnish with plenty of chopped green onions.|7. Serve hot with salt and pepper on the side for dipping.
3114	481	1	Fry the black bean paste in a bit of oil for a few minutes to remove bitterness, then set aside.|2. In a pan, stir-fry the pork until cooked, then add onions, cabbage, and zucchini.|3. Stir the fried black bean paste into the meat and vegetables.|4. Pour in water, add sugar, and bring to a simmer until the vegetables are soft.|5. Pour in the starch slurry to thicken the dark sauce.|6. Boil the noodles in a separate pot, drain, and place in a serving bowl.|7. Ladle the hot black bean sauce over the noodles and serve immediately.
3115	482	1	Soak the short ribs in cold water for an hour to extract excess blood, then parboil and rinse.|2. Place the cleaned ribs in a large pot with fresh water, onion, and garlic, then bring to a boil.|3. Lower the heat and simmer for an hour, adding the radish chunks halfway through.|4. Remove the onion and garlic, and slice the cooked radish into bite-sized pieces.|5. Season the clear broth with soup soy sauce, salt, and pepper.|6. Add the soaked starch noodles to the bowl and ladle the boiling soup and ribs over them.|7. Top with chopped green onions and serve.
3116	483	1	Sauté garlic and gochugaru in sesame oil over low heat to create a chili oil base.|2. Add the seafood or pork and stir-fry quickly.|3. Pour in the anchovy broth and bring to a boil.|4. Scoop the silken tofu into the pot in large chunks.|5. Season the soup with fish sauce or salt to taste.|6. Add green onions and let it boil for 3 minutes.|7. Crack a raw egg directly into the boiling stew right before serving.
3117	484	1	Boil the glass noodles until chewy, drain, and toss with a little soy sauce and sesame oil.|2. Blanch the spinach, squeeze dry, and season with salt and sesame oil.|3. Stir-fry the carrots, onions, and mushrooms separately with a pinch of salt.|4. Cook the beef strips with soy sauce, sugar, and garlic.|5. In a large mixing bowl, combine the noodles, vegetables, and beef together.|6. Pour in a mixture of soy sauce, sugar, and sesame oil, tossing everything gently by hand.|7. Garnish with sesame seeds and serve warm or at room temperature.
3118	485	1	Make a marinade by mixing gochujang, gochugaru, soy sauce, sugar, garlic, and ginger.|2. Coat the chicken pieces in the marinade and rest for 30 minutes.|3. Heat a large skillet or skillet pan with a little oil.|4. Add the marinated chicken, sweet potatoes, cabbage, and rice cakes.|5. Stir-fry over medium-high heat until the chicken and sweet potatoes are fully cooked.|6. Toss in green onions and perilla leaves at the end.|7. Serve directly from the skillet.
3119	486	1	Shave frozen milk or regular ice into a serving bowl.|2. Spoon a generous amount of sweetened red bean paste directly onto the center of the ice.|3. Drizzle condensed milk evenly over the shaved ice.|4. Scatter chewy mini rice cakes around the red bean paste.|5. Dust with misugaru powder if desired.|6. Serve immediately.
3120	487	1	Let the yeast dough rise until it doubles in size.|2. Mix brown sugar, cinnamon, and chopped nuts together in a small bowl for the filling.|3. Take a piece of dough, flatten it in your hand, and place a spoonful of filling in the center.|4. Seal the dough tightly around the filling to form a ball.|5. Place the ball into a hot, oiled pan and press it flat with a presser or spatula.|6. Fry until golden brown on both sides, making sure the sugar inside melts into a syrup.|7. Serve warm.
3121	488	1	Rub sesame oil into the wheat flour until well incorporated, then sift.|2. Mix honey, water, ginger juice, and salt, then gently knead into the flour to form a dough.|3. Roll out the dough and cut it into traditional flower shapes or squares.|4. Deep-fry the pastry shapes in low-temperature oil first, then increase the heat to brown them.|5. Drain the fried pastries and submerge them in a warm honey-ginger syrup for several hours.|6. Remove from syrup, drain excess, and let them set before serving.
3122	489	1	Mix glutinous rice flour with hot water and a pinch of salt to form a smooth dough.|2. Roll the dough into bite-sized balls (stuffed with red bean paste if preferred).|3. Drop the balls into boiling water and cook until they float to the surface.|4. Transfer the cooked balls into an ice bath to cool down and become chewy.|5. Drain the water completely.|6. Roll the balls in your choice of roasted soybean powder or black sesame powder until coated.|7. Serve at room temperature.
3123	490	1	Preheat a fish-shaped waffle mold iron over the stove.|2. Brush the molds lightly with melted butter or oil.|3. Pour a thin layer of batter into each fish mold.|4. Add a scoop of sweet red bean paste into the center of the batter.|5. Pour more batter over the red bean paste to cover it completely.|6. Close the mold and cook over low-medium heat, flipping occasionally, until both sides are golden brown.|7. Remove carefully and serve warm.
3124	491	1	Knead the rice flour with hot water until a smooth, pliable dough forms.|2. Take small pieces of dough, shape into a small bowl, and add your preferred sweet filling.|3. Fold and pinch the edges tightly to form a signature half-moon shape.|4. Line a steamer tray with clean, fresh pine needles.|5. Arrange the rice cakes on top and steam for about 20 minutes.|6. Rinse the steamed cakes quickly in cold water, remove stray needles, and brush lightly with sesame oil.|7. Serve cool.
3125	492	1	Knead glutinous rice flour with hot water and a touch of salt into a soft dough.|2. Divide the dough into small pieces and flatten them into small, round discs.|3. Gently rinse and dry the edible flower petals.|4. Heat a pan with oil over low heat and pan-fry the rice discs.|5. Carefully press an edible flower petal onto the top side of each disc while cooking.|6. Flip briefly to set the flower, being careful not to burn it.|7. Remove from heat, drizzle with honey or sugar syrup, and serve.
3126	493	1	Pour sweet sikhye beverage (including some rice grains) into a shallow baking dish.|2. Place the dish flat in the freezer for about 2 hours.|3. Take the dish out and use a fork to thoroughly scrape the frozen parts into ice crystals.|4. Return to the freezer and repeat the scraping process every hour until it reaches a uniform slush texture.|5. Scoop the icy granita into a dessert bowl.|6. Garnish with a few pine nuts on top and serve cold.
3127	494	1	Mix glutinous rice flour, sugar, salt, and water in a microwave-safe bowl.|2. Cover and microwave for 2 minutes, stir, then microwave for another 1 minute until sticky and translucent.|3. Pound the hot dough briefly with a wooden spoon to increase chewiness.|4. Dust a clean surface generously with cornstarch and roll out the dough.|5. Cut into squares, place a ball of red bean paste in the center of each, and seal the edges.|6. Coat the outside lightly with starch so it isn't sticky.|7. Let cool and serve.
3128	495	1	Peel the sweet potatoes and cut them into bite-sized, irregular chunks.|2. Deep-fry the sweet potato chunks in hot oil until the inside is soft and the outside turns golden brown. Drain.|3. In a clean pan, combine sugar and water over medium heat without stirring until it melts into a golden syrup.|4. Quickly toss the fried sweet potatoes into the caramel syrup, coating each piece evenly.|5. Transfer the glazed chunks onto a greased plate, spacing them out so they don't stick together.|6. Sprinkle with black sesame seeds and let the glaze cool and harden before serving.
3129	496	1	Soak malted barley powder in warm water, stir, and strain the liquid, leaving the sediment behind.|2. Pour the clear malt water into a rice cooker over cooked white rice.|3. Keep the rice cooker on the "warm" setting for 4 to 5 hours until rice grains begin to float.|4. Pour the liquid and rice into a large pot, add sugar, and boil for 10 minutes.|5. Skim off any foam from the surface.|6. Chill thoroughly in the refrigerator.|7. Serve ice-cold, garnished with a few pine nuts.
3130	497	1	Boil ginger and cinnamon sticks in separate pots of water to extract their individual flavors cleanly.|2. Strain both liquids into one large pot, discarding the ginger pieces and cinnamon sticks.|3. Add sugar and simmer for another 10 minutes until completely dissolved, then let the punch cool down.|4. Refrigerate the liquid until cold.|5. Slice dried persimmons and soak them in the punch shortly before serving so they soften.|6. Ladle into cups and garnish with a few pine nuts.
3131	498	1	Scoop 2 to 3 tablespoons of yuja cheong into a teacup.|2. Pour hot water directly over the preserve.|3. Stir thoroughly until the sweet syrup blends completely with the water.|4. Let it steep for a minute so the citrus rinds release their flavor.|5. Serve hot (can also be served over ice for a cold option).
3132	499	1	Bring a large pot of water to a rolling boil.|2. Add a handful of roasted barley grains directly into the boiling water.|3. Reduce the heat to low and let it simmer for about 15 to 20 minutes until the water turns a light amber color.|4. Turn off the heat and let it steep for another 10 minutes.|5. Strain out the barley grains.|6. Serve warm or transfer to a bottle and chill in the refrigerator to drink cold.
3133	500	1	Add misugaru powder into a blender or shaker bottle.|2. Pour in cold milk or water.|3. Drizzle in honey or sugar to suit your preferred sweetness.|4. Blend or shake vigorously until the powder is fully dissolved and smooth with no lumps.|5. Pour into a glass filled with ice cubes.|6. Serve cold as a refreshing snack or breakfast drink.
3134	501	1	Dredge chicken in flour, dip in beaten eggs, and coat thoroughly with panko.|2. Deep-fry the chicken cutlet until golden brown and crispy, then slice into strips.|3. In a separate pot, sauté sliced onions, carrots, and potatoes.|4. Add water or dashi broth and simmer until the vegetables are tender.|5. Turn off the heat, drop in the curry roux blocks, and stir until completely dissolved.|6. Simmer on low heat for a few minutes until the curry sauce thickens.|7. Plate a serving of rice, place the crispy chicken on top, and pour the hot curry sauce over it.
3135	502	1	Boil pork bones in water for several hours until the marrow breaks down and the broth becomes milky and creamy.|2. Prepare the tare seasoning by simmering soy sauce, mirin, and a bit of garlic.|3. Boil the ramen noodles in a separate pot until al dente, then drain.|4. Place a spoonful of tare base at the bottom of a serving bowl.|5. Pour the boiling tonkotsu pork broth over the tare and stir.|6. Add the noodles and neatly arrange the chashu, soft-boiled egg, green onions, and nori on top.|7. Serve immediately while piping hot.
3136	503	1	In a pan, combine dashi broth, soy sauce, mirin, and sugar, then bring to a boil.|2. Add the sliced onions and cook until they become soft and translucent.|3. Add the thinly sliced beef to the simmering liquid and cook quickly until no longer pink.|4. Skim off any foam or fat that floats to the surface.|5. Fill a bowl with warm, steamed rice.|6. Ladle the beef, onions, and a generous splash of the sweet savory broth over the rice.|7. Garnish with pickled red ginger and serve hot.
3137	504	1	Mix soy sauce, mirin, sake, sugar, and grated ginger in a bowl to create the teriyaki sauce.|2. Heat oil in a pan and place the chicken skin-side down, cooking until the skin is crispy and golden.|3. Flip the chicken over and cook the other side until completely done.|4. Wipe away any excess rendered fat from the pan using a paper towel.|5. Pour the teriyaki sauce mixture into the pan with the chicken.|6. Simmer over medium heat, spooning the sauce over the chicken continuously until it reduces into a thick glaze.|7. Slice the chicken, drizzle with the remaining pan glaze, and serve.
3138	505	1	Whisk the egg yolk and ice-cold water together, then gently mix in the tempura flour (leave lumps for maximum crispiness).|2. Heat a generous amount of oil in a deep pot to around 170°C to 180°C.|3. Dust the shrimp and vegetable slices lightly with dry flour.|4. Dip each piece into the cold tempura batter, ensuring a light coating.|5. Drop carefully into the hot oil and deep-fry for 2 to 3 minutes until pale gold and crispy.|6. Drain on a wire rack or paper towels.|7. Serve immediately accompanied by warm tentsuyu dipping sauce and grated radish.
3139	506	1	Mix soy sauce, mirin, sake, and sugar in a pot and bring to a light boil to make the sukiyaki broth (warishita).|2. Heat a shallow hot pot pan and sear a few pieces of beef, then pour in a bit of the broth.|3. Arrange the tofu, mushrooms, green onions, and shirataki noodles neatly in separate sections of the pot.|4. Pour the remaining warishita broth over the ingredients and let it simmer until everything is cooked through.|5. Beat a raw egg in a small individual dipping bowl.|6. Take the cooked beef and vegetables directly from the pot, dip into the raw egg, and eat immediately.
3140	507	1	Combine dashi, soy sauce, mirin, and sugar in a small skillet and bring to a simmer.|2. Add the sliced onions and cook until softened.|3. Slice the pre-cooked tonkatsu pork cutlet and place it directly on top of the simmering onions.|4. Drizzle the beaten egg evenly over the pork cutlet and onions.|5. Cover the skillet with a lid and cook on low heat for 1 to 2 minutes until the egg is softly set but still runny.|6. Slide the entire mixture carefully over a large bowl of warm rice.|7. Serve hot.
3141	508	1	Pour dashi broth, soy sauce, mirin, and sugar into a small pan and heat until simmering.|2. Add the chicken pieces and sliced onions, cooking until the chicken is tender and no longer pink.|3. Pour the beaten eggs in a circular motion over the chicken and onions.|4. Cover with a lid and let the egg cook for about 1 minute until it is partially set.|5. Turn off the heat while the egg is still glossy and soft.|6. Slide the chicken and egg smoothly over a bowl of warm rice.|7. Serve immediately.
3142	509	1	Heat oil in a large pan or griddle and stir-fry the pork belly until browned.|2. Add the onions, carrots, and cabbage, cooking until the vegetables are slightly wilted but still crisp.|3. Add the yakisoba noodles to the pan along with a splash of water to help loosen them up.|4. Stir-fry everything together until the noodles are well incorporated.|5. Pour the yakisoba sauce over the noodles and toss vigorously to coat evenly.|6. Transfer to a plate.|7. Garnish with a dusting of aonori and a side of pickled red ginger.
3143	510	1	Sprinkle a generous amount of coarse sea salt on both sides of the mackerel fillets and let sit for 20 minutes to draw out moisture.|2. Wipe the fillets completely dry with a paper towel and lightly salt them again.|3. Preheat a fish broiler, oven grill, or grill pan and oil the grate lightly.|4. Place the mackerel skin-side down and grill until the skin becomes crispy and blisters.|5. Flip the fillets over and grill the flesh side until cooked through and juicy.|6. Place on a serving plate alongside a mound of grated daikon radish.|7. Drizzle soy sauce over the radish and serve warm.
3144	511	1	In a microwave-safe bowl, whisk together the glutinous rice flour, matcha powder, sugar, and water until smooth.|2. Cover the bowl loosely and microwave for 2 minutes. Stir well, then microwave for another 1 minute until sticky.|3. Dust a clean surface generously with cornstarch and transfer the hot dough onto it.|4. Divide the dough into equal pieces and flatten them into small rounds.|5. Place a small ball of sweet red bean paste in the center of each round.|6. Pinch the edges of the mochi dough together to seal it completely.|7. Shape into smooth balls and serve at room temperature.
3145	512	1	Whisk eggs, sugar, and honey together until fluffy, then sift in the flour and baking powder.|2. Stir in water or milk to create a smooth, slightly thick pancake batter, then let it rest for 10 minutes.|3. Lightly oil a non-stick pan over low heat and wipe off excess oil completely.|4. Pour a small ladle of batter to form a small, neat circle.|5. Cook until bubbles appear on the surface, then flip and cook the other side for 1 minute. Repeat to make an even number of pancakes.|6. Let the pancakes cool down completely.|7. Spread a generous dollop of sweet red bean paste onto one pancake and sandwich it with another.
3146	513	1	Whisk the matcha powder and sugar together in a small bowl.|2. Gradually whisk in a small portion of warm milk until the matcha dissolves smoothly with no remaining lumps.|3. In a larger bowl, combine the matcha mixture, remaining milk, heavy cream, and a pinch of salt.|4. Stir thoroughly and chill the liquid mixture in the refrigerator for at least 2 hours.|5. Pour the chilled base into an ice cream maker and churn according to the manufacturer's directions until soft-serve consistency.|6. Scoop into a bowl or pipe into a waffle cone.|7. Serve immediately.
3147	514	1	Whisk honey and warm water together in a small bowl until dissolved.|2. Whip the eggs and sugar together using an electric mixer on high speed until thick, pale, and ribbon-like.|3. Add the honey mixture and fold in carefully.|4. Sift the bread flour into the egg mixture in stages, folding gently with a spatula to keep the volume.|5. Pour the batter into a loaf pan lined with parchment paper.|6. Bake in a preheated oven at 160°C for about 40 to 45 minutes until a toothpick inserted comes out clean.|7. Wrap the warm cake tightly in plastic wrap to lock in moisture and let it rest in the fridge overnight before slicing.
3148	515	1	Combine the rice flours and warm water, kneading gently until a smooth dough forms.|2. Roll the dough into small, uniform balls.|3. Boil the balls in water until they float, then cook for another 2 minutes before transferring to an ice bath.|4. Thread 3 to 4 dumplings onto each bamboo skewer.|5. In a saucepan, simmer soy sauce, mirin, sugar, water, and potato starch until a thick, clear, shiny glaze forms.|6. Quickly sear the skewered dumplings on a grill pan until slightly charred.|7. Brush the sweet soy glaze generously over the warm dango and serve.
3149	516	1	Bake a standard sponge cake, let it cool completely, and slice horizontally into two even layers.|2. Whip the heavy cream and powdered sugar together until stiff peaks form.|3. Brush the bottom sponge cake layer lightly with simple sugar syrup to keep it moist.|4. Spread a layer of whipped cream over the sponge and arrange sliced strawberries evenly on top.|5. Apply more whipped cream over the strawberries, then place the second sponge layer on top.|6. Frost the entire top and sides of the cake smoothly with the remaining whipped cream.|7. Decorate the top with whole strawberries and chill before serving.
3150	517	1	Whisk together flour, baking powder, sugar, and salt, then blend in the egg and milk until a smooth batter forms.|2. Preheat a taiyaki (fish-shaped) waffle iron over a medium-low flame and brush lightly with oil.|3. Pour batter into one side of the mold until it is half full.|4. Place a rectangular dollop of custard or red bean paste along the center of the fish mold.|5. Pour more batter on top to cover the filling completely.|6. Close the iron tightly and flip it immediately.|7. Cook for 2 to 3 minutes on each side until the exterior is a deep golden brown and crispy. Serve hot.
3151	518	1	Dissolve gelatin powder in a small bowl with a few tablespoons of warm water.|2. Mix hot, freshly brewed black coffee and sugar together in a pot until the sugar melts.|3. Stir the dissolved gelatin into the hot coffee mixture thoroughly.|4. Pour the mixture into a shallow rectangular dish.|5. Allow it to cool to room temperature, then place in the refrigerator for 3 hours until completely firm.|6. Slice the coffee gelatin into small cubes.|7. Divide cubes into glasses and pour heavy cream or sweet evaporated milk over them before serving cold.
3152	519	1	Boil agar-agar powder and water in a pot for 2 minutes, pour into a container, and let it set into a firm jelly.|2. Cut the firm agar jelly into bite-sized cubes.|3. Arrange the jelly cubes at the bottom of a serving bowl.|4. Place a scoop of sweet red bean paste in the center.|5. Decorate the bowl around the red bean paste with the fruit pieces and chewy mochi.|6. Drizzle a generous amount of dark kuromitsu syrup over all the ingredients.|7. Serve chilled.
3153	520	1	Heat sugar and water in a saucepan over medium heat without stirring until it caramelizes into a dark brown syrup.|2. Pour the hot caramel immediately into the bottom of individual ramekin cups and let it harden.|3. Warm the milk and sugar in a pot until the sugar dissolves (do not boil).|4. Whisk eggs in a bowl, then slowly pour in the warm milk mixture while stirring constantly. Add vanilla extract.|5. Strain the custard liquid through a fine sieve into the caramel cups to ensure smoothness.|6. Place ramekins in a baking dish filled with hot water halfway up the sides.|7. Bake at 150°C for 35 to 40 minutes, cool down, chill, and unmold onto plates to serve.
3154	521	1	Sift the matcha powder into a bowl to remove any tiny lumps.|2. Pour a small amount of hot water (about 80°C) into the bowl.|3. Use a bamboo whisk (chasen) to whisk vigorously in a zig-zag motion until a frothy green layer forms.|4. Heat your milk and froth it slightly if desired.|5. Pour the warm milk into a serving cup.|6. Gently pour the whisked matcha tea on top of the milk.|7. Sweeten with honey or sugar if preferred and serve hot.
3155	522	1	Place 1 to 2 tablespoons of genmaicha leaves into a Japanese teapot (kyusu).|2. Boil water and let it cool slightly to about 80°C to 85°C to avoid burning the green tea leaves.|3. Pour the hot water over the tea leaves in the teapot.|4. Close the lid and allow the tea to steep for exactly 30 seconds to 1 minute.|5. Pour the tea into cups in alternating small increments to distribute the flavor evenly.|6. Serve hot.
3156	523	1	Place hojicha tea leaves into a teapot.|2. Unlike regular green tea, boil water completely to 95°C to 100°C to extract the roasted aroma.|3. Pour the boiling water directly over the hojicha leaves.|4. Let the tea steep for about 30 seconds to a minute.|5. Pour completely out into tea cups so the remaining leaves don't become bitter.|6. Serve hot as a relaxing after-meal drink.
3157	524	1	Thoroughly chill the bottle of Ramune in the refrigerator before opening.|2. Peel off the plastic seal from the cap and remove the plastic plunger tool.|3. Place the bottle firmly on a flat, stable surface.|4. Position the plunger over the glass marble at the top of the bottle neck.|5. Push down hard with the palm of your hand until the marble pops down into the glass chamber below.|6. Hold down for a few seconds to prevent the carbonation from bubbling over, then drink cold.
3158	525	1	Fill a large pitcher with 1 to 2 liters of cold tap or filtered water.|2. Drop a large mugicha cold-brew tea bag directly into the water.|3. Place the pitcher into the refrigerator.|4. Let it steep cold for 1 to 2 hours until the water turns a deep amber brown color.|5. Remove the tea bag from the pitcher to prevent the tea from turning bitter.|6. Pour into a glass packed with ice cubes and enjoy cold.
3159	526	1	Marinate chicken cubes with a bit of soy sauce and cornstarch for 15 minutes.|2. Mix soy sauce, black vinegar, sugar, and a splash of water in a bowl to make the sauce.|3. Heat oil in a wok and fry the dried chilies and Sichuan peppercorns until fragrant.|4. Add the marinated chicken and stir-fry until it turns white.|5. Toss in the minced garlic, ginger, and scallions.|6. Pour in the sauce mixture and stir quickly as it thickens.|7. Stir in the roasted peanuts and serve hot.
3160	527	1	Blanch the tofu cubes in hot, salted water for 1 minute, then drain carefully.|2. Heat oil in a wok and fry the minced meat until crispy, then push to the side.|3. Add the chili bean paste, garlic, and ginger, stir-frying until the oil turns red.|4. Pour in the chicken broth and bring to a simmer.|5. Gently slide the tofu cubes into the sauce and simmer for 5 minutes.|6. Swirl in the cornstarch slurry to thicken the gravy.|7. Transfer to a bowl and dust heavily with ground Sichuan peppercorn powder before serving.
3161	528	1	Marinate the pork pieces with a splash of soy sauce, coat with egg yolk, and dredge thoroughly in cornstarch.|2. Deep-fry the pork pieces until cooked through, then fry a second time at a higher heat for maximum crispiness.|3. In a clean wok, mix ketchup, vinegar, sugar, and a little water, heating until boiling.|4. Stir-fry the bell peppers, onions, and pineapple chunks in the sauce for 1 minute.|5. Toss the crispy fried pork quickly into the boiling sauce.|6. Coat every piece evenly and remove from heat immediately.|7. Serve hot while the pork is still crunchy.
3162	529	1	Clean the duck, pump air under the skin to separate it from the meat, and scald the skin with boiling water.|2. Brush the entire duck with the maltose syrup mixture and hang it to dry completely for several hours.|3. Roast the duck in an oven until the skin turns a shiny, deep mahogany brown and becomes crispy.|4. Carve the crispy skin and tender meat into thin slices.|5. To assemble, spread a smear of sweet bean sauce onto a thin pancake.|6. Place a few pieces of duck skin/meat, cucumber, and scallion matchsticks inside.|7. Roll tightly and enjoy.
3163	530	1	Marinate the beef slices with soy sauce, cornstarch, and a tiny pinch of baking soda for 20 minutes.|2. Blanch the broccoli florets in boiling water for 1 minute, then plunge into cold water to keep them bright green.|3. Heat oil in a wok over high heat and sear the beef slices quickly until browned but tender; remove from wok.|4. Sauté minced garlic and ginger in the remaining oil until fragrant.|5. Pour in oyster sauce, soy sauce, a splash of rice wine, and a bit of water.|6. Return the beef and the blanched broccoli to the wok, tossing rapidly to coat them in the bubbling brown sauce.|7. Serve hot with rice.
3164	531	1	Mix ground pork, shrimp, soy sauce, sesame oil, and white pepper together to form the wonton filling.|2. Place a small spoonful of filling onto a wonton wrapper, fold, and pinch to seal securely.|3. Bring the seasoned chicken or pork bone broth to a gentle simmer in a pot.|4. In a separate pot of boiling water, cook the fresh egg noodles until al dente, then drain and transfer to a bowl.|5. Boil the wontons and leafy greens in the water until the wontons float and are cooked through.|6. Place the cooked wontons and greens neatly on top of the noodles.|7. Ladle the clear, piping-hot broth over the bowl and serve.
3165	532	1	Heat oil in a wok and soft-scramble the beaten eggs, then break them into small bits and set aside.|2. Stir-fry the diced carrots, peas, char siu pork, and shrimp until cooked.|3. Add the cold, day-old rice to the wok, breaking up any large clumps with the back of a spatula.|4. Stir-fry vigorously over high heat until the rice grains are hot and toasted.|5. Return the scrambled eggs to the wok and season with salt, white pepper, or a light splash of soy sauce.|6. Toss in the freshly chopped scallions during the last 30 seconds.|7. Serve hot.
3166	533	1	Boil the whole chunk of pork belly in water with ginger and rice wine for 20 minutes until parboiled; let it cool.|2. Slice the cooled pork belly into very thin, bite-sized strips.|3. Heat a wok over medium heat (no oil needed) and stir-fry the pork slices until they curl slightly and render their fat.|4. Push the pork to the side, then add the chili bean paste and sweet bean paste to the center, cooking until aromatic.|5. Mix the pork back into the sauce, tossing in the garlic, ginger, and sliced Chinese leeks.|6. Stir-fry quickly on high heat until the leeks are tender-crisp.|7. Serve hot.
3167	534	1	Clean the fish thoroughly and make a few shallow diagonal cuts on both sides of the flesh.|2. Place the fish on a steaming plate, scattering a portion of the ginger slices on top and inside the cavity.|3. Steam over high heat for 8 to 10 minutes until the flesh flakes easily with a fork; discard any accumulated liquid.|4. Arrange a generous mound of fresh julienned scallions and remaining ginger on top of the hot fish.|5. Heat a few tablespoons of cooking oil in a small pan until smoking hot.|6. Carefully pour the hot oil directly over the scallions and ginger to sizzle and release their fragrance.|7. Pour a warm mixture of light soy sauce and a pinch of sugar around the base of the fish and serve.
3168	535	1	Blanch the pork belly cubes in boiling water for 3 minutes to remove impurities, then drain.|2. In a pot over low heat, melt rock sugar in a little oil until it turns into a golden-brown caramel syrup.|3. Add the pork cubes to the pot and stir quickly to coat them with the caramel.|4. Pour in the rice wine, light soy sauce, dark soy sauce, and enough water to submerge the meat.|5. Throw in the ginger slices, star anise, and cinnamon stick.|6. Bring to a boil, then cover and simmer on low heat for 1 hour until the pork is incredibly tender.|7. Uncover and crank up the heat to reduce the liquid into a thick, glossy glaze that clings to the pork. Serve hot.
3169	536	1	Dissolve sugar in warm water and let it cool completely.|2. Whisk egg yolks, evaporated milk, vanilla extract, and the cooled sugar water together.|3. Strain the liquid custard mixture through a fine sieve to ensure it is silky smooth.|4. Roll out the pastry dough and press into small tart molds.|5. Pour the egg custard mixture into the pastry shells until 80% full.|6. Bake in a preheated oven at 200°C (400°F) for 15 to 20 minutes until the crust is golden and the custard sets.|7. Serve warm.
3170	537	1	Pour the hot sugar water into the glutinous rice flour and knead into a smooth, pliable dough.|2. Divide dough into small pieces, flatten, and wrap around a small ball of red bean paste, sealing completely.|3. Dampen the dough balls slightly with water, then roll them in white sesame seeds until fully coated.|4. Heat oil to a low temperature (around 150°C) and drop the balls in.|5. Fry while gently pressing down on the balls with a spatula to help them expand and become hollow.|6. Once they float and turn golden brown and crispy, drain excess oil.|7. Serve warm.
3171	538	1	Blend the majority of the mango cubes with coconut milk and evaporated milk until completely smooth.|2. Pour the mango puree into a large serving bowl.|3. Stir in the cooked, drained sago pearls.|4. Garnish the top generously with the remaining fresh mango cubes and shredded pomelo pulp.|5. Chill in the refrigerator for at least 2 hours.|6. Serve cold.
3172	539	1	Soak the dried red beans in water overnight to soften.|2. Drain the beans and place them in a pot with fresh water and the dried tangerine peel.|3. Bring to a boil, then lower the heat, cover, and simmer for 1 to 1.5 hours until the beans are completely soft.|4. Use a wooden spoon to mash a portion of the beans against the side of the pot to thicken the soup texture.|5. Add rock sugar to taste and stir until completely melted.|6. Serve warm.
3173	540	1	Mix black sesame powder, sugar, and melted butter together, then freeze until firm to make the filling.|2. Knead glutinous rice flour with warm water until a smooth dough forms.|3. Wrap small portions of the dough around cubes of the cold black sesame filling, rolling into smooth spheres.|4. In a separate pot, boil water with rock sugar and sliced ginger to make a sweet, warming broth.|5. Drop the rice balls into a separate pot of boiling water; cook until they float to the top.|6. Transfer the cooked balls into bowls and ladle the sweet ginger broth over them.|7. Serve hot.
3174	541	1	Dissolve agar-agar powder in water and bring to a simmer for 2 minutes.|2. Stir in the milk, sugar, and almond extract until everything is fully incorporated.|3. Pour the mixture through a strainer into a flat dish.|4. Let it cool to room temperature, then refrigerate until firm and set.|5. Slice the almond jelly into neat diamond-shaped cubes.|6. Place cubes into a bowl, top with canned fruits and light syrup, and serve chilled.
3175	542	1	Dissolve the brown sugar completely in warm water and let it cool down.|2. Sift the all-purpose flour, rice flour, and baking powder together in a mixing bowl.|3. Pour the sugar water into the dry ingredients and whisk until a thick, smooth batter forms.|4. Pour the batter into small cups or molds lined with paper liners until almost completely full.|5. Bring a steamer to a rolling boil over high heat.|6. Place the cups into the steamer, cover tightly, and steam on high heat for 15 minutes without opening the lid.|7. Remove once the tops have cracked open wide into a "smile" and serve warm.
3176	543	1	Cook milk, sugar, and cornstarch in a pan over low heat, stirring continuously until it turns into a thick paste.|2. Pour the paste into a greased rectangular dish, smooth the surface, and freeze until completely solid.|3. Cut the frozen milk block into bite-sized rectangular sticks.|4. Whisk flour, baking powder, water, and a little oil together to make a smooth, thick frying batter.|5. Coat the frozen milk sticks thoroughly in the batter.|6. Deep-fry immediately in hot oil for 2 to 3 minutes until the shell turns golden and crispy while the inside melts.|7. Drain and serve immediately.
3177	544	1	Melt butter in a non-stick pan over very low heat.|2. Add the marshmallows and stir continuously until they are completely melted and smooth.|3. Turn off the heat and quickly stir in the milk powder until fully blended.|4. Throw in the biscuit pieces, dried cranberries, and chopped nuts, folding the sticky marshmallow mixture over them.|5. Transfer the warm mixture onto a piece of parchment paper and press it firmly into a thick square block.|6. Dust both sides generously with extra milk powder to resemble snow.|7. Allow to cool completely and become firm before slicing into neat little squares.
3178	545	1	Boil water with rock sugar until dissolved, then add the dried osmanthus flowers to steep for 5 minutes.|2. Stir agar-agar powder into the hot floral tea, cooking for another 2 minutes.|3. Pour a thin layer of the liquid into a mold and place it in the fridge briefly to partially set.|4. Stir the remaining liquid occasionally so the flowers don't all settle to the bottom.|5. Pour another layer over the first one once it's tacky to the touch.|6. Refrigerate the completed mold for 3 hours until completely firm.|7. Slice into translucent cubes and serve cold.
3179	546	1	Brew a strong cup of black tea and let it cool down slightly.|2. Place a generous scoop of cooked tapioca pearls at the bottom of a tall glass.|3. Drizzle brown sugar syrup over the pearls to sweeten them.|4. In a shaker bottle, combine the brewed tea, milk, and ice, shaking vigorously.|5. Pour the milk tea mixture into the glass over the pearls.|6. Serve cold with a wide straw.
3180	547	1	Place a handful of dried chrysanthemum flowers into a teapot.|2. Pour boiling hot water over the flowers.|3. Add rock sugar to the pot according to your preference.|4. Cover the teapot and let it steep for 5 minutes until the water turns a delicate yellow color.|5. Stir to ensure the rock sugar is fully dissolved.|6. Strain the tea into cups and serve hot (or let it cool and chill in the fridge for a refreshing iced tea).
3181	548	1	Rinse the smoked plums, hawthorn berries, and licorice root under running water.|2. Place all the herbs into a large pot with water and let them soak for 30 minutes.|3. Bring the pot to a boil, then turn down the heat and simmer gently for 40 minutes.|4. Stir in the rock sugar until completely dissolved.|5. Strain the dark liquid into a pitcher, discarding the solid ingredients.|6. Chill thoroughly in the refrigerator and serve cold, ideally during a spicy hot pot meal.
3182	549	1	In a bowl, whip the softened cream cheese, milk, sugar, and sea salt together until smooth.|2. In a separate bowl, whip the heavy cream until it reaches soft peaks.|3. Gently fold the cream cheese mixture into the whipped cream to create a thick, velvety foam.|4. Fill a tall glass with ice cubes and pour the chilled green or oolong tea over them, leaving space at the top.|5. Carefully spoon the salted cream cheese foam on top of the tea so it floats in a thick layer.|6. Serve cold without a straw, drinking at an angle to taste both the cream and tea together.
3183	550	1	Soak the raw yellow soybeans in plenty of water overnight until they expand.|2. Drain and rinse the soaked beans.|3. Blend the beans with fresh water in a high-speed blender until completely smooth.|4. Pour the mixture through a nut milk bag or fine cheesecloth, squeezing hard to extract the milk and separate the pulp (okara).|5. Pour the raw soy milk into a pot and bring it to a boil over medium heat, stirring constantly so the bottom doesn't burn.|6. Let it simmer on low heat for 10 minutes to cook through safely.|7. Stir in sugar to taste and serve warm in a bowl or cup.
3184	551	1	Heat oil in a wok and sauté the minced shallots, garlic, and chili paste until fragrant.|2. Add the chicken pieces and shrimp, stir-frying until cooked through.|3. Push the ingredients to the side, crack an egg into the wok, and scramble it.|4. Add the cold cooked rice to the wok, breaking up any clumps.|5. Pour in the sweet soy sauce and toss everything vigorously over high heat until the rice is evenly coated and toasted.|6. Season with a pinch of salt and pepper.|7. Serve hot, topped with fried shallots and a fried egg on the side.
3185	552	1	Blend the spice paste ingredients until smooth and place into a large, deep pot.|2. Add the beef chunks, coconut milk, lemongrass, and lime leaves into the pot, stirring well.|3. Bring the mixture to a boil over medium heat, stirring occasionally.|4. Lower the heat to a gentle simmer and let it cook uncovered for several hours until the liquid reduces drastically.|5. Stir in the toasted grated coconut (kerisik) to thicken and impart flavor.|6. Continue cooking and stirring frequently as the oil renders and the beef browns in its own fat.|7. Remove from heat when the dish is dark brown and almost dry, then serve.
3186	553	1	Marinate the chicken cubes in sweet soy sauce, coriander, turmeric, and oil for 1 hour.|2. Thread 3 to 4 pieces of marinated chicken onto each bamboo skewer.|3. To make the sauce, sauté ground shallots, garlic, and candlenuts, then add ground peanuts and water.|4. Simmer the peanut mixture with brown sugar and sweet soy sauce until it thickens and oil separates.|5. Grill the chicken skewers over hot charcoal or a grill pan, turning regularly and brushing with marinade until charred and cooked.|6. Place the grilled skewers on a plate.|7. Ladle the warm peanut sauce over the top and serve.
3187	554	1	Prepare all the vegetables by boiling or blanching them lightly until tender but crisp.|2. Deep-fry the tofu and tempeh until golden brown, then slice into bite-sized pieces.|3. Warm up the pre-made peanut dressing in a small pan, adding a splash of water if it is too thick.|4. Arrange the blanched vegetables, potatoes, fried tofu, tempeh, and boiled egg slices neatly on a serving platter.|5. Pour the rich peanut dressing generously over the top of the arranged ingredients.|6. Garnish with a handful of crispy prawn crackers.|7. Serve immediately.
3188	555	1	In a pot, combine the chicken pieces with the spice paste, galangal, lemongrass, and bay leaves. Add water to cover.|2. Simmer until the chicken is cooked through and the liquid reduces, allowing the spices to cling to the meat.|3. Remove the chicken from the pot and let it drain, keeping the remaining paste and oil.|4. Heat oil in a deep fryer or wok until hot.|5. Deep-fry the chicken pieces until golden brown and crispy.|6. Fry the remaining paste in the oil until crispy as well, then drain.|7. Serve the chicken hot, topped with the crispy galangal and spice flakes.
3189	556	1	Simmer beef bones, garlic, and white pepper in a large pot of water for several hours to create a rich broth.|2. Drop the beef meatballs (bakso) directly into the simmering broth until they heat through and float.|3. Blanch the yellow noodles or vermicelli in boiling water, then drain and place into a serving bowl.|4. Ladle the hot beef broth and several meatballs over the noodles.|5. Garnish with chopped celery, scallions, and fried garlic.|6. Serve hot with sweet soy sauce and sambal on the side for dipping.
3190	557	1	Sauté the spice paste with lemongrass, lime leaves, and bay leaves until highly aromatic.|2. Add the chicken pieces and pour in water, bringing the soup to a boil.|3. Simmer until the chicken is fully cooked, then remove the chicken, shred the meat, and discard the bones.|4. Place a handful of glass noodles and bean sprouts into a serving bowl.|5. Top with the shredded chicken meat and a slice of hard-boiled egg.|6. Ladle the boiling, fragrant yellow broth over the ingredients in the bowl.|7. Serve hot with a squeeze of lime juice.
3191	558	1	Coat the fish fillets thoroughly with the prepared spice paste.|2. Lay out a piece of banana leaf and place a few basil leaves, a tomato slice, and a piece of lemongrass on it.|3. Place the spiced fish fillet on top, then add more basil leaves over the fish.|4. Roll the banana leaf tightly around the fish, folding the ends inward and securing them with toothpicks.|5. Steam the wrapped parcels for 20 minutes to cook the fish through.|6. Transfer the parcels to a hot grill pan, grilling for 5 minutes on each side until the banana leaves are charred.|7. Unwrap and serve warm.
3192	559	1	Heat oil in a wok and sauté the chopped garlic until fragrant.|2. Add the chicken strips or fish balls, stir-frying until they change color.|3. Toss in the harder vegetables like carrots and cauliflower, stir-frying for 2 minutes.|4. Add the leafy greens, mushrooms, and cabbage into the wok.|5. Pour in a splash of chicken broth and season with oyster sauce, soy sauce, and fish sauce.|6. Stir quickly over high heat until the vegetables are tender but still crisp.|7. Pour in the cornstarch slurry, stir until the sauce thickens into a glossy glaze, and serve hot.
3193	560	1	Blend the soaked kluwek flesh together with the spice paste ingredients until smooth.|2. Sauté the black paste in a pot with lemongrass and lime leaves until fragrant.|3. Add the cubed beef brisket to the pot, tossing to coat with the paste until seared.|4. Pour in water and bring to a boil.|5. Lower the heat, cover, and let it simmer for about 1.5 to 2 hours until the beef becomes tender.|6. Season with salt and sugar to balance the earthy flavor.|7. Serve hot, traditionally accompanied by salted egg and bean sprouts.
3194	561	1	In a dessert bowl or wide glass, arrange chunks of avocado, jackfruit strips, and shredded coconut.|2. Heap a generous mound of shaved ice over the fruit.|3. Drizzle simple sugar syrup over the ice to sweeten.|4. Pour condensed milk heavily over the top for richness.|5. Serve immediately with a spoon to mix before eating.
3195	562	1	Pour the batter into a preheated, greased heavy iron skillet, creating a lip around the edges.|2. Cook on low heat until bubbles form on the surface and the batter sets.|3. Sprinkle a little sugar over the top, cover with a lid, and cook until the center is dry.|4. Remove the pancake from the pan and spread a large dollop of butter over the hot surface.|5. Fill one half with chocolate sprinkles, crushed peanuts, grated cheese, and a drizzle of condensed milk.|6. Fold the pancake in half to enclose the fillings, brush the outer crust with more butter, slice, and serve warm.
3196	563	1	Mix glutinous rice flour with pandan juice and warm water, kneading gently into a smooth dough.|2. Pinch off a small piece of dough and flatten it into a disc in your palm.|3. Place a small amount of chopped palm sugar in the center.|4. Fold the edges over and roll tightly into a smooth, seamless ball.|5. Drop the balls carefully into a pot of boiling water.|6. Cook until they float to the surface, then let them boil for 2 more minutes to ensure the sugar melts inside.|7. Remove with a slotted spoon and roll the hot balls immediately in the steamed grated coconut before serving.
3197	564	1	In a pot, whisk together the rice flour, coconut milk, a pinch of salt, and a pandan leaf until smooth.|2. Place the pot over medium-low heat and stir continuously to prevent lumps from forming.|3. Cook until the mixture thickens into a smooth, glossy, porridge-like consistency, then remove and let cool.|4. In a separate saucepan, boil palm sugar and water with a pandan leaf until it dissolves into a syrup.|5. Strain the palm sugar syrup to remove impurities.|6. Scoop a portion of the white pudding into a bowl.|7. Drizzle the warm palm sugar syrup generously over it and serve.
3198	565	1	Whisk together the rice flour, all-purpose flour, baking powder, sugar, salt, and ice-cold water to create a crispy batter.|2. Heat a generous amount of cooking oil in a deep pan.|3. Dip each banana slice into the batter, ensuring it is completely covered.|4. Carefully drop the battered bananas into the hot oil.|5. Deep-fry until the outer crust turns a beautiful golden brown and becomes exceptionally crunchy.|6. Drain excess oil on paper towels.|7. Serve warm while crispy.
3199	566	1	To make the filling, simmer palm sugar, water, and a pandan leaf until dissolved, then stir in the grated coconut until dry.|2. Whisk the crepe batter ingredients together until smooth and strain to remove any tiny lumps.|3. Heat a lightly greased non-stick skillet over medium-low heat.|4. Pour a small ladle of batter into the pan, swirling quickly to form a thin green crepe; cook until set and remove.|5. Place a spoonful of the sweet coconut filling near the edge of a crepe.|6. Fold the sides inward and roll up tightly like a spring roll.|7. Serve at room temperature.
3200	567	1	Boil water, palm sugar, and a pandan leaf in a pot until the sugar completely dissolves.|2. Add the banana slices to the sweet liquid and simmer for 5 minutes.|3. Pour in the coconut milk along with a pinch of salt to balance the sweetness.|4. Lower the heat to avoid curdling the coconut milk.|5. Stir gently and let it simmer until the bananas are soft and tender.|6. Remove from heat.|7. Serve warm or chilled in small bowls.
3201	568	1	Whip the egg yolks and powdered sugar until thick and pale; fold in the whipped butter and flour with spices.|2. Grease a square baking pan and line the bottom with parchment paper.|3. Pour a thin layer of batter into the pan and spread it evenly.|4. Bake under the oven broiler/grill for a few minutes until golden brown.|5. Remove the pan, press down lightly to flatten air bubbles, and pour another thin layer of batter over the baked layer.|6. Repeat this process layer by layer until all the batter is used up and a multi-layered cake is formed.|7. Cool completely, slice thinly, and serve.
3202	569	1	Steam the cassava chunks in a steamer until completely soft and cooked through.|2. While still hot, discard any hard fibrous veins from the center of the cassava.|3. Mash the cassava thoroughly using a mortar or potato masher.|4. Add sugar and a pinch of salt into the warm mashed cassava, kneading until fully dissolved and blended.|5. Mix in food coloring if a vibrant presentation is desired.|6. Press the dough into a flat mold and cut into neat small squares or run it through a grinder for a shredded look.|7. Serve topped generously with steamed grated coconut.
3203	570	1	Cook rice flour, coconut milk, sugar, and salt in a pot over low heat, stirring until it turns into a thick dough.|2. Take a piece of softened banana leaf and place a scoop of the warm rice flour dough onto it.|3. Press a slice of banana directly into the center of the dough, covering it up completely.|4. Fold the banana leaf securely around the dough to form a neat rectangular parcel.|5. Arrange the wrapped parcels inside a steamer basket.|6. Steam over medium heat for about 20 to 25 minutes until set.|7. Let them cool completely before unwrapping and serving.
3204	571	1	Pour a generous portion of thick palm sugar syrup into the bottom of a tall serving glass.|2. Add a scoop of green cendol jelly droplets over the syrup layer.|3. Fill the glass to the top with crushed ice.|4. Slowly pour the salted coconut milk over the ice to create a beautiful layered look.|5. Serve cold along with a straw and spoon.
3205	572	1	Add 1 to 2 tablespoons of fine coffee grounds into a coffee mug.|2. Add sugar into the mug according to your personal preference.|3. Pour boiling water directly over the coffee grounds and sugar.|4. Stir vigorously for a few seconds to ensure everything mixes well.|5. Let the coffee stand undisturbed for 3 to 5 minutes.|6. Once all the coffee grounds have completely settled to the bottom of the mug, drink hot.
3206	573	1	Place the bruised ginger and lemongrass into a pot filled with water.|2. Bring the water to a rolling boil over medium-high heat.|3. Lower the heat and let it simmer for 15 minutes to extract the hot ginger flavor.|4. Stir in the palm sugar until it completely dissolves into the tea.|5. Strain the hot liquid through a sieve into a cup, removing the ginger and lemongrass.|6. Serve hot.
3207	574	1	Crack open a fresh young coconut, pouring the sweet water into a large pitcher.|2. Scrape out the tender white coconut flesh using a spoon and stir it into the water.|3. Taste the juice and mix in a splash of simple syrup if additional sweetness is desired.|4. Stir thoroughly until mixed.|5. Pour into glasses over ice cubes.|6. Serve chilled.
3208	575	1	Place the avocado flesh, milk, sugar syrup, and ice cubes into a blender.|2. Blend on high speed until the mixture becomes smooth, thick, and creamy.|3. Take a serving glass and drizzle chocolate condensed milk along the inner walls in a swirl pattern.|4. Carefully pour the thick avocado blend into the chocolate-lined glass.|5. Top with an extra drizzle of chocolate syrup if desired.|6. Serve cold with a straw.
3209	576	1	Heat oil in a large pot and sauté the chopped onions until translucent.|2. Add the tomato paste and fry for a few minutes to remove the sour taste.|3. Pour in the blended tomato and pepper mixture, frying until the oil separates at the top.|4. Stir in the curry powder, thyme, bay leaves, salt, and seasoning cubes.|5. Pour in the chicken or beef stock and bring the mixture to a rolling boil.|6. Wash the parboiled rice thoroughly, add it to the pot, and stir gently.|7. Cover tightly with foil and a lid, cooking on low heat until the rice absorbs the liquid and becomes tender.|8. Turn off the heat, let it steam for a few minutes, and serve hot with fried plantains.
3210	577	1	Boil the assorted meats and dried fish with onions and seasoning until tender; reserve the broth.|2. Mix the ground egusi with a small amount of warm water to form a thick paste.|3. Heat palm oil in a pot, add the egusi paste chunks, and fry gently until firm and crumbly.|4. Pour in the blended pepper mix and cooked meat broth, stirring well to combine.|5. Add the cooked meats, dried fish, and ground crayfish, then simmer for 15 minutes.|6. Stir in the chopped greens and let it cook for another 5 minutes before removing from heat.|7. For the pounded yam, boil yam chunks until soft, then pound vigorously in a mortar or food processor until smooth and stretchy.|8. Serve the hot soup alongside the pounded yam.
3211	578	1	Thread the thin strips of beef carefully onto the bamboo skewers.|2. Generously coat the skewered meat with the yaji spice blend, pressing it into the flesh.|3. Let the spiced meat marinate for at least 30 minutes.|4. Brush the meat lightly with vegetable oil to keep it moist during cooking.|5. Grill the skewers over hot charcoal or a grill pan, turning regularly until cooked through and slightly charred.|6. Remove from the grill and dust with a final layer of yaji spice.|7. Serve hot with a side of sliced raw onions and tomatoes.
3212	579	1	Boil the assorted meats and stockfish until completely tender, keeping the stock.|2. Heat palm oil in a pot on low heat, add the ground ogbono seeds, and stir continuously until completely dissolved.|3. Slowly pour in the warm meat stock while stirring rapidly to prevent lumps and encourage the draw texture.|4. Add the cooked meats, stockfish, and ground crayfish to the pot.|5. Simmer on low-medium heat for 15 minutes, stirring occasionally so the bottom doesn't burn.|6. Toss in the chopped vegetables if desired, cooking for 3 minutes before turning off the heat.|7. Boil and pound the white yam until it forms a smooth, pillowy dough.|8. Serve warm together.
3213	580	1	Squeeze out excess water from the blanched and chopped spinach leaves very thoroughly.|2. Heat palm oil in a pot and fry the sliced onions and iru (locust beans) until fragrant.|3. Add the coarsely blended pepper mix and fry down until the water content evaporates completely.|4. Stir in the diced beef, stockfish, smoked fish, and ground crayfish.|5. Season with bouillon cubes and salt, allowing it to simmer for 10 minutes.|6. Fold the chopped spinach into the rich pepper sauce, mixing gently.|7. Simmer on low heat for 3 to 5 minutes so the vegetables don't overcook, then serve.
3214	581	1	Place the goat meat chunks into a pot with chopped onions, salt, and a little seasoning, cooking until the meat juices run out.|2. Pour in a generous amount of water and bring to a rolling boil.|3. Stir in the ground scotch bonnets and the native pepper soup spice mix.|4. Cover the pot and simmer on medium heat until the meat is thoroughly tender.|5. Adjust the salt and seasoning to taste.|6. Scatter the chopped scent leaves over the boiling soup.|7. Simmer for another 2 minutes and serve piping hot in a bowl.
3215	582	1	To make gbegiri, boil peeled beans until mushy, puree them, then cook with palm oil, crayfish, and seasoning until smooth.|2. Cook the chopped ewedu leaves in a little water with iru and a pinch of potash, then whisk until slimy and smooth.|3. For the amala, vigorously stir the elubo flour into a pot of boiling water over low heat until a smooth, dark, stretchy dough forms.|4. Mold the amala into a ball and place it in a serving bowl.|5. Ladle the yellow gbegiri soup and green ewedu soup over the amala together (this mixture is called Abula).|6. Top with a generous scoop of the spicy pepper sauce and assorted meats.|7. Serve warm.
3216	583	1	Boil the short-grain rice with plenty of water until it is completely soft and overcooked.|2. Use a wooden spatula to mash the soft rice together until it forms a smooth, sticky dough, then mold into balls.|3. For the stew, boil the pumpkin cubes in a separate pot until soft, then mash into a smooth paste.|4. Sauté the blended tomato and pepper mix in a pot, then add the cooked meat and pumpkin paste.|5. Stir in the ground roasted peanuts and pour in a bit of meat stock to loosen the texture.|6. Simmer for 15 minutes on low heat, stirring continuously as the peanut thickens the stew.|7. Stir in the chopped leaves, cook for 3 minutes, and serve hot with the rice balls.
3217	584	1	Boil the parboiled rice directly in a well-seasoned chicken stock infused with curry powder and thyme until it is al dente. Drain any excess liquid.|2. Heat vegetable oil in a large wok or pan.|3. Sauté the onions, carrots, green beans, sweet corn, and diced liver quickly for 3 minutes.|4. Add the cooked yellow rice to the pan in small batches.|5. Stir-fry vigorously over high heat, tossing the rice with the vegetables and liver evenly.|6. Adjust seasoning with a pinch of salt if necessary.|7. Remove from heat and serve warm, typically with fried chicken.
3218	585	1	Season the goat meat pieces with salt, black pepper, and onions, then roast or grill until cooked and smoky.|2. Heat a small amount of vegetable oil in a wok or large pan.|3. Sauté the chopped onions for a minute.|4. Add the coarsely chopped scotch bonnet peppers, frying for 3 minutes.|5. Toss the grilled smoky goat meat directly into the hot pepper mixture.|6. Stir-fry over high heat for 5 minutes, ensuring the pepper sauce coats every piece of meat thoroughly.
3219	586	1	Dissolve the yeast and a tablespoon of sugar in warm water and let it sit until frothy.|2. In a bowl, mix the flour, remaining sugar, salt, and a pinch of nutmeg together.|3. Pour the yeast liquid into the flour mixture, beating by hand until a smooth, stretchy batter forms.|4. Cover the bowl with a cloth and leave it in a warm place for 45 minutes to rise and double in size.|5. Heat a deep pan filled with vegetable oil.|6. Scoop the batter using your fingertips or a spoon, dropping balls of dough into the hot oil.|7. Fry until the balls flip over easily and turn completely golden brown on all sides; drain and serve warm.
3220	587	1	Whisk flour, sugar, baking powder, and nutmeg together in a large bowl.|2. Rub the butter into the flour mixture using your fingers until it resembles fine breadcrumbs.|3. Mix the egg and milk together, then pour into the dry ingredients.|4. Knead gently until a smooth, firm dough forms.|5. Roll the dough flat onto a floured surface to a thickness of about 1/4 inch.|6. Use a knife or pizza cutter to slice the dough into tiny squares or strips.|7. Deep-fry the dough pieces in hot oil until they turn crispy and golden brown, then cool completely before eating.
3221	588	1	Dissolve yeast in warm water and let it activate for 10 minutes.|2. Peel the overripe plantains and mash them in a bowl with a fork or mortar until completely smooth.|3. Stir the flour, yeast liquid, chili flakes, and salt into the mashed plantains, mixing into a thick batter.|4. Cover the batter and let it rest for 20 minutes to rise slightly.|5. Heat oil in a pan over medium heat.|6. Drop small spoonfuls of the batter into the hot oil.|7. Fry until the fritters are browned and cooked through, then serve warm.
3222	589	1	In a saucepan, combine sugar and water over medium heat, stirring until the sugar dissolves.|2. Add the freshly shredded coconut flakes to the sugar syrup, stirring well.|3. Cook the mixture on medium-low heat, stirring continuously as the water evaporates.|4. Watch closely as the sugar begins to caramelize and turn the coconut a light golden-brown color.|5. Once the mixture becomes very sticky and dry, remove it from the heat.|6. Spoon small portions onto a greased tray and mold into balls or discs while warm.|7. Allow them to cool down completely and harden before serving.
3223	590	1	In a mixing bowl, thoroughly combine the desiccated coconut flakes and powdered sugar.|2. Add the egg yolks to the dry mixture, kneading by hand until a stiff, moldable paste forms.|3. Pinch off small pieces of the coconut mixture and roll them into small balls.|4. Roll each ball lightly through a bowl of self-rising flour to coat the exterior.|5. Arrange the balls neatly on a baking sheet lined with parchment paper.|6. Bake in a preheated oven at 170°C (340°F) for 15 minutes until the tops turn golden.|7. Let them cool before serving.
3224	591	1	Rub cold butter into the flour, then add cold water to form a smooth dough; wrap and rest in the fridge.|2. Cook the ground beef, diced carrots, and potatoes in a pan, seasoning with bouillon, salt, and a dash of sugar until tender.|3. Roll out the rested pastry dough and cut out circular discs.|4. Spoon a portion of the meat and vegetable filling into the center of each disc.|5. Fold the dough over to form a half-moon shape, sealing the edges firmly with the tines of a fork.|6. Poke a few holes on top, brush with beaten egg, and bake at 180°C for 30 minutes until golden brown.|7. Serve warm.
3225	592	1	Blend the roasted peanuts in a high-speed processor until it forms a smooth paste (peanut butter consistency).|2. Wrap the paste in a clean muslin cloth and squeeze hard to express as much oil as possible, leaving a dry cake.|3. Mix the dry peanut cake with chili powder, ground ginger, and a pinch of salt.|4. Shape the seasoned dough into small rings, cylinders, or balls.|5. Heat the peanut oil extracted earlier in a pan.|6. Fry the peanut shapes until they turn a dark golden brown and become hard and brittle.|7. Remove, let cool completely to crisp up, and serve.
3226	593	1	Mix flour, yeast, sugar, and salt together in a large bowl.|2. Gradually add warm water, kneading until a soft, elastic bread dough forms.|3. Divide the dough into small rounds and flatten them into discs.|4. Let the discs rise for 15 minutes.|5. Traditionally baked in a clay oven, you can bake them on a hot heavy skillet or oven until puffed up and lightly browned.|6. Drizzle with warm honey or sprinkle with sugar while hot.|7. Serve warm as a sweet bread treat.
3227	594	1	Blend the peeled beans with a minimal amount of water until a very smooth, thick paste forms.|2. Pour the paste into a bowl and stir in sugar to taste along with a small pinch of salt.|3. Use a wooden spoon to whisk the batter vigorously in a circular motion for 5 minutes to incorporate air.|4. Heat vegetable oil in a deep pan.|5. Scoop spoonfuls of the airy batter into the hot oil.|6. Fry until the cakes puff up, flip, and turn a beautiful golden color on both sides.|7. Drain and serve hot.
3228	595	1	Whisk flour, sugar, and baking powder together in a bowl.|2. Add milk and an egg, beating thoroughly into a smooth, pourable pancake-like batter.|3. Pour the batter into a squeeze bottle or a funnel with a small opening.|4. Heat oil in a shallow frying pan.|5. Squeeze the batter into the hot oil in a circular, criss-cross spiral pattern.|6. Fry for 1 to 2 minutes until golden and crispy on the bottom, then flip carefully.|7. Remove, drain, and dust heavily with powdered sugar before serving warm.
3229	596	1	Rinse the dust off the dried hibiscus petals quickly under cold running water.|2. Place the petals into a large pot along with the crushed ginger, cloves, and pineapple slices.|3. Pour in a generous amount of water and bring to a rolling boil over high heat.|4. Lower the heat and let it simmer for 30 minutes to fully extract the flavors and rich red color.|5. Turn off the heat and let the mixture cool down completely.|6. Strain the liquid through a fine cloth sieve into a pitcher, discarding the solids.|7. Stir in sugar or honey to taste, then chill thoroughly in the refrigerator before serving over ice.
3230	597	1	Soak the hard dry tiger nuts in plenty of water for 24 hours to soften them up, then rinse.|2. Soak the pitted dates in warm water for an hour to soften.|3. Combine the soaked tiger nuts, soft dates, coconut meat, and ginger in a blender with cold water.|4. Blend on high speed until completely smooth and milky.|5. Pour the blended mixture through a nut milk bag or fine chiffon cloth, squeezing tightly to extract all the milk.|6. Discard the dry fiber pulp left in the bag.|7. Transfer the creamy milk into a bottle and refrigerate immediately; serve ice-cold.
3231	598	1	Fill a large dimpled mug or highball glass with plenty of ice cubes.|2. Pour in a splash of Grenadine syrup or blackcurrant cordial at the bottom.|3. Pour equal parts of Fanta Orange and Sprite into the glass until nearly full.|4. Add a few drops (around 3 to 5 drops) of Angostura bitters to give it its signature taste.|5. Drop cucumber slices, orange wheels, and lemon wedges directly into the drink.|6. Stir gently with a straw to blend the layers.|7. Serve ice-cold with a garnish.
3232	599	1	Soak the millet grains in water overnight, then wash thoroughly.|2. Blend the millet together with the ginger, cloves, and sweet potatoes into a smooth paste.|3. Divide the thick paste into two unequal portions (one 3/4 portion, one 1/4 portion).|4. Pour boiling water over the large 3/4 portion, stirring vigorously to cook it into a thick porridge.|5. Let the cooked porridge cool down completely, then stir the raw 1/4 portion back into it.|6. Cover and leave the mixture overnight to ferment and thin out naturally.|7. The next morning, strain the liquid through a fine mesh cloth, add sugar to taste, and serve chilled.
3233	600	1	Fresh palm wine is gathered by tapping the sap of palm tree flower stems.|2. When drunk immediately after tapping, it is sweet, non-alcoholic, and cloudy white.|3. Allow it to sit at room temperature for a few hours to naturally ferment via wild yeasts, transforming the sugars into alcohol and creating a fizzy, tart profile.|4. Once it reaches your preferred level of fermentation, transfer the container into the refrigerator to slow down the process.|5. Pour carefully into glasses, leaving any natural white sediment at the bottom of the jug if preferred.|6. Serve chilled.
3234	601	1	Sauté the chopped onions in a pan until soft, then add the minced meat and brown it.|2. Stir in the curry powder, turmeric, apricot jam, and raisins.|3. Squeeze the excess milk from the soaked bread, mash it up, and mix it thoroughly into the meat.|4. Transfer the spiced meat mixture into a greased baking dish and press it down flat.|5. Whisk the eggs and milk together with a pinch of salt to create the custard.|6. Pour the egg mixture carefully over the meat and arrange a few bay leaves on top.|7. Bake at 180°C for about 30 minutes until the egg custard topping is set and golden brown.
3235	602	1	Sauté onions, ginger, garlic, and curry leaves in a large pot until fragrant.|2. Add the curry powder and garam masala, stirring quickly to toast the spices.|3. Toss in the meat cubes and cook until browned on all sides.|4. Add the chopped tomatoes and a splash of water, then cover and simmer.|5. Once the meat begins to soften, add the potato cubes and cook until the gravy is thick and the potatoes are tender.|6. Take a portion of the bread loaf and hollow out the dense center crumb, leaving the crust walls intact.|7. Ladle the hot, thick curry into the hollowed bread bowl and serve immediately with the extra bread crumb on top for dipping.
3236	603	1	Mix the minced beef, pork, and diced fat gently in a large bowl.|2. Add the crushed coriander, black pepper, nutmeg, cloves, salt, and brown vinegar, tossing lightly so the meat doesn't become mushy.|3. Feed the seasoned meat mixture into the sausage casings using a sausage stuffer.|4. Coil the long continuous sausage into a spiral without twisting it into individual links.|5. Prepare a hot charcoal braai (barbecue) grid.|6. Grill the boerewors coil carefully over the coals, turning it only once to keep the juices inside.|7. Remove when browned but juicy, and serve hot with pap or on a roll.
3237	604	1	Build a coal fire and place the cast-iron pot (potjie) directly over the heat.|2. Brown the meat pieces in oil, then remove them briefly to sauté the sliced onions and garlic.|3. Return the meat to the pot, layer it at the bottom, and pour in the red wine and beef stock.|4. Pack the harder vegetables like carrots and potatoes neatly in layers on top of the meat.|5. Close the heavy lid tightly and do not stir the ingredients at all during the cooking process.|6. Let it simmer slowly over low coals for 3 to 4 hours, adding softer vegetables like mushrooms near the end.|7. Stir gently just once before serving to mix the rich bottom gravy with the vegetables.
3238	605	1	For the pap, bring salted water to a boil in a pot, whisk in the maize meal vigorously, cover, and steam on low heat until smooth and thick.|2. To make chakalaka, fry onions, garlic, ginger, and chilies in oil until soft.|3. Stir in the hot curry powder and cook for 1 minute to release the aromatics.|4. Add the bell peppers, cabbage, and grated carrots, stir-frying until tender but still holding texture.|5. Pour in the canned baked beans and stir well to combine.|6. Let the mixture simmer on low heat for 5 minutes until the flavors fuse together.|7. Serve the spicy vegetable relish either hot or cold over a generous portion of warm pap.
3239	606	1	Melt the butter in a small saucepan, then stir in the apricot jam, minced garlic, and lemon juice to create the glaze.|2. Pat the butterflied snoek fish completely dry with a paper towel and season the flesh with salt and pepper.|3. Place the fish skin-side down onto a well-greased folding braai grid.|4. Brush a generous layer of the apricot jam glaze over the exposed flesh.|5. Grill high over gentle coals skin-side down first for about 10 minutes, brushing with extra glaze.|6. Flip the grid over and grill the flesh side for just a few minutes until beautifully browned and flakey.|7. Serve hot with fresh bread and sweet potatoes.
3240	607	1	Sear the mutton pieces in a large, heavy-based pot until browned, then remove.|2. In the same pot, fry onions, ginger, garlic, and whole spices until fragrant and dark gold.|3. Return the meat to the pot, add the chopped tomatoes, and bring to a simmer.|4. Cover tightly, lower the heat, and let it cook slowly for 1.5 hours in the tomato juices until the meat is tender.|5. Toss in the quartered potatoes and a pinch of sugar to balance the tomatoes.|6. Simmer uncovered until the potatoes are cooked and the gravy has reduced to a thick, rich consistency.|7. Serve hot with a side of white rice.
3241	608	1	Sauté onions, garlic, and curry powder in a pan, then add the minced beef and brown it completely.|2. Add the carrots and peas, cooking until soft and dry; set the savory mince aside.|3. Divide the risen yeast bread dough into palm-sized balls.|4. Deep-fry the dough balls in medium-hot oil until puffed up, crisp, and golden brown on all sides.|5. Drain the fried bread (vetkoek) on paper towels.|6. Slice the warm vetkoek open down the middle to form a deep pocket.|7. Spoon a generous amount of the warm curried mince inside and serve immediately.
3242	609	1	Marinate the meat pieces with the ground coriander, allspice, salt, and pepper for an hour.|2. Fry the sliced onions in a heavy pot until they are very dark brown and caramelized.|3. Add the marinated meat and bay leaves into the pot, searing well with the onions.|4. Pour in the dissolved tamarind water and a pinch of sugar.|5. Cover with a tight lid, reduce the heat to low, and slow-cook for 2 hours.|6. Check occasionally, adding small splashes of water if the stew becomes too dry.|7. Remove from heat when the meat is completely tender and coated in a sour-sweet dark glaze, then serve with yellow rice.
3243	610	1	Combine the rice, water, turmeric powder, and cinnamon stick in a pot.|2. Bring the water to a boil, then stir in the butter, sugar, and raisins.|3. Lower the heat to a simmer, cover the pot tightly with a lid, and let cook for 15 to 20 minutes.|4. Turn off the heat once all the liquid is completely absorbed.|5. Leave the lid on to let the rice steam undisturbed for 5 minutes.|6. Remove the cinnamon stick and fluff the bright yellow rice gently with a fork to distribute the raisins.|7. Serve hot as a side dish for curries and bredies.
3244	611	1	Whisk the egg and sugar together until thick, then beat in the apricot jam and melted butter.|2. Dissolve the baking soda in milk and stir it into the egg mixture alternately with the flour and vinegar.|3. Pour the smooth batter into a greased baking dish and bake at 180°C for 30 minutes until browned.|4. While baking, boil all the cream sauce ingredients together in a saucepan for 2 minutes.|5. Remove the pudding from the oven and pierce hot surface holes all over using a fork.|6. Pour the warm cream sauce evenly over the hot pudding, letting it soak in completely.|7. Serve warm with a side of custard or vanilla ice cream.
3245	612	1	Line a tart dish with the pastry dough, prick the bottom with a fork, and bake blind until golden; let cool.|2. Bring the milk to a boil in a pot along with a cinnamon stick, then remove from heat.|3. In a bowl, whisk eggs, sugar, flour, and cornstarch together until smooth.|4. Slowly temper the egg mixture by pouring the hot milk into it while whisking constantly.|5. Return the whole custard mix to the pot and cook over low heat, stirring continuously until it turns thick.|6. Stir in the butter and vanilla extract, then pour the smooth custard into the baked tart shell.|7. Dust the surface heavily with cinnamon powder and refrigerate until completely set before slicing.
3246	613	1	Boil the sugar, water, ginger, and lemon juice to make a syrup, then chill it in the freezer until ice-cold.|2. Rub butter into the flour and baking powder, then add milk to form a pliable pastry dough.|3. Roll the dough out thin and cut into strips, braiding three strips together and pinching the ends tightly.|4. Deep-fry the braided dough pieces in hot oil until they are dark golden brown and crispy.|5. Lift the hot pastry straight from the oil and submerge it instantly into the ice-cold ginger syrup.|6. Let the koeksister soak up the cold syrup for a few seconds so it becomes juicy inside.|7. Drain on a wire rack and serve chilled.
3247	614	1	Whip the heavy cream in a large bowl until stiff peaks form.|2. Fold the canned caramel treat into the whipped cream gently until completely smooth.|3. Arrange a neat, flat layer of coconut biscuits at the bottom of a rectangular glass dish.|4. Spread a thick layer of the caramel cream mixture evenly over the biscuits.|5. Sprinkle a generous handful of the grated peppermint crisp chocolate over the cream.|6. Repeat the layers (biscuits, cream, chocolate) until the dish is full, finishing with a dense layer of chocolate on top.|7. Place in the refrigerator for at least 4 hours (or overnight) to allow the biscuits to soften before slicing.
3248	615	1	Roll out the pastry dough and cut out small rounds using a cookie cutter.|2. Press the dough rounds into the cups of a greased muffin or tartlet pan.|3. Spoon a small dollop of smooth apricot jam into the center of each pastry cup.|4. Whip the egg whites and sugar together in a clean bowl until stiff, glossy peaks form.|5. Gently fold the desiccated coconut flakes into the whipped meringue.|6. Spoon or pipe a cap of the coconut meringue over the jam layer, sealing it inside.|7. Bake at 180°C for 15 to 20 minutes until the pastry is cooked through and the coconut topping is beautifully toasted.
3249	616	1	Pour boiling water over the chopped dates and baking soda, letting them sit until soft and mushy.|2. Cream the butter and sugar, beat in the egg, then fold in the flour, soft dates, and pecans.|3. Pour into a baking dish and bake at 180°C for 35 minutes until firm.|4. While it bakes, boil the sugar, water, and butter for the syrup, then remove from heat and stir in the brandy.|5. Prick the hot baked pudding with a skewer as soon as it comes out of the oven.|6. Pour the hot brandy syrup evenly over the pudding, letting it saturate the cake.|7. Serve warm with cream or custard.
3250	617	1	Sift the flour, baking powder, and spices together in a large bowl, then rub in the butter and lard.|2. Whisk the egg, sugar, and red wine together until the sugar dissolves.|3. Pour the liquid into the dry ingredients and knead gently to form a firm, aromatic cookie dough.|4. Roll out the dough on a floured surface to a thickness of 5mm.|5. Cut into round shapes using a fluted cookie cutter.|6. Arrange on a baking sheet and bake at 180°C for 12 to 15 minutes until lightly browned and crisp.|7. Allow to cool completely before storing or serving.
3251	618	1	Mix the rolled oats, coconut flakes, flour, and sugar together in a large bowl.|2. Melt the butter and golden syrup together in a saucepan over medium heat.|3. Stir the baking soda into the melted butter mixture (it will froth up beautifully).|4. Pour the foaming liquid into the dry oat mixture, stirring rapidly to combine.|5. Press the mixture firmly and evenly into a greased baking tin.|6. Bake at 160°C for about 25 to 30 minutes until deep golden brown.|7. Slice into neat squares while still warm, then let cool completely in the tin to crisp up.
3252	619	1	Mix the flour, sugar, salt, and whole aniseeds together in a large bowl.|2. Combine the yeast with warm milk and melted butter, then pour into the dry ingredients.|3. Knead the dough thoroughly for 10 minutes until smooth and elastic, then let rise until doubled in size.|4. Shape the dough into small, uniform balls.|5. Pack the balls tightly next to each other inside a greased loaf pan.|6. Let them rise again until they crowd the pan and puff upwards.|7. Bake at 180°C for 30 minutes, brushing the tops with sugar water as soon as they emerge to create a shiny, sticky crust.
3253	620	1	Dissolve the gelatin powder in a small cup of cool water.|2. Mix hot, freshly brewed rooibos tea with honey and a splash of lemon juice until dissolved.|3. Stir the gelatin mixture into the hot rooibos tea, whisking until fully dissolved and transparent.|4. Pour the clear amber liquid through a sieve into individual dessert molds or glasses.|5. Allow to cool down to room temperature.|6. Place in the refrigerator for at least 4 hours until completely set.|7. Serve chilled, optionally topped with a dollop of fresh cream.
3254	621	1	Place a rooibos tea bag or a teaspoon of loose leaves into a teacup.|2. Pour boiling hot water directly over the tea.|3. Let it steep for 5 to 7 minutes (rooibos does not turn bitter the longer it sits).|4. Remove the tea bag or strain the leaves.|5. Enjoy as a clear herbal tea, or add a splash of milk and a drizzle of honey to sweeten.|6. Serve hot.
3255	622	1	Place 3 large scoops of vanilla ice cream into a blender.|2. Pour in a splash of heavy cream and a generous shot of Amarula cream liqueur.|3. Blend on high speed for just a few seconds until smooth, thick, and creamy.|4. Take a chilled wine glass or coupe glass.|5. Pour the thick milkshake cocktail smoothly into the glass.|6. Dust the top with a pinch of cocoa powder or grated chocolate.|7. Serve immediately with a straw.
3256	623	1	Prepare a very thin, smooth maize meal porridge with water and let it cool completely to room temperature.|2. Stir a tablespoon of wheat flour into the cooled porridge mixture to introduce natural yeasts.|3. Pour the mixture into a clean jar or container, leaving space at the top, and seal loosely.|4. Place the container in a warm room for 1 to 2 days to naturally ferment.|5. Watch for tiny bubbles and a distinctly pleasant sour aroma to develop.|6. Once fermented, stir in sugar to your preferred level of sweetness.|7. Chill thoroughly in the refrigerator and shake well before serving cold.
3257	624	1	Pack a tall highball glass to the top with ice cubes.|2. Fill half of the glass with crisp ginger beer.|3. Slowly top up the remaining half with sweet cream soda.|4. Add 2 to 3 drops of Angostura bitters onto the surface.|5. Watch the bitters bleed down through the carbonated layers.|6. Stir very gently with a straw to combine the flavors without losing the fizz.|7. Serve ice-cold.
3258	625	1	Boil water in a pot, whisk in the sorghum meal, and cook for 15 minutes to form a thin porridge.|2. Allow the sorghum porridge to cool completely down to lukewarm or room temperature.|3. Stir in a handful of crushed sorghum malt grains to initiate the fermentation process.|4. Cover the pot with a clean cloth and leave it undisturbed in a warm spot for 24 hours.|5. The beverage will develop a sharp, tangy flavor and a bubbly texture.|6. Strain out any coarse grain husks if a smoother texture is preferred.|7. Refrigerate and serve ice-cold.
3259	626	1	Boil the lentils and rice together or separately until tender, then layer them at the bottom of the serving dish.|2. Boil the macaroni in salted water, drain, and layer it over the rice and lentils.|3. Fry the thinly sliced onions in a generous amount of oil until dark brown and crispy; drain on paper towels.|4. Use some of the onion-infused oil to sauté garlic, add tomato paste and crushed tomatoes, and simmer into a thick sauce.|5. Make a separate sharp sauce (da'ah) by mixing minced garlic, vinegar, cumin, salt, and warm water.|6. Top the pasta layer with warm chickpeas and a mountain of crispy fried onions.|7. Ladle the hot tomato sauce and garlic-vinegar da'ah over the top before serving.
3260	627	1	Boil the chicken pieces with onions, cardamom, mastic, and bay leaves to create a highly flavorful broth.|2. Remove the chicken and roast or pan-fry it until golden brown; set aside.|3. Bring 3 to 4 cups of the strained chicken broth to a gentle simmer in a pot.|4. Add the minced molokhia leaves to the broth, whisking vigorously to remove lumps, and simmer on low heat (do not let it boil over).|5. In a separate small pan, melt ghee and sauté the minced garlic and coriander powder until golden brown and intensely fragrant (called the "taqleyah").|6. Pour the hot sizzling garlic mixture directly into the molokhia pot, stirring quickly to combine.|7. Serve the green soup hot alongside the crispy chicken and plain white rice.
3261	628	1	Sauté the chopped onions in ghee until soft, then add the freekeh or rice and toast for a few minutes.|2. Season the grains heavily with cinnamon, nutmeg, allspice, salt, and pepper.|3. Pour in a small splash of broth and cook until the grains are halfway done, then let the stuffing cool completely.|4. Stuff the inner cavity and the neck skin of each pigeon carefully with the spiced grain mixture.|5. Sew or skewer the openings shut so the filling doesn't spill out during cooking.|6. Boil the stuffed pigeons in a seasoned broth for 30 to 40 minutes until the meat is thoroughly tender.|7. Remove from the broth, dry the skin, brush with melted ghee, and roast in the oven or pan-fry until dark golden and crispy.
3262	629	1	Boil the beef chunks with onions and spices until fork-tender, reserving the rich broth.|2. Cook the short-grain white rice with ghee and a splash of broth until fluffy.|3. Toast the flatbread squares in the oven or fry them in ghee until deeply crispy.|4. Sauté minced garlic in ghee, then deglaze the pan with white vinegar and a ladle of beef broth to create the garlic-vinegar sauce.|5. In a separate pot, cook tomato sauce with a bit of the garlic-vinegar mixture.|6. Assemble by placing the crispy bread at the bottom of a dish, drenching it with the plain garlic-vinegar broth.|7. Spread the cooked rice evenly over the bread, arrange the beef chunks on top, and drizzle with the warm tomato sauce.
3263	630	1	Hollow out the center of the zucchini and eggplants using a coring tool, and cap the bell peppers.|2. Sauté the chopped onions in oil, add the tomato puree, and simmer until thick.|3. Turn off the heat and stir in the washed raw rice, fresh herbs, cumin, coriander powder, salt, and pepper.|4. Stuff the hollowed vegetables loosely with the rice mixture (leave room for the rice to expand).|5. Arrange the stuffed vegetables tightly and upright in a large, deep pot.|6. Pour hot seasoned broth into the pot until it reaches halfway up the vegetables.|7. Bring to a boil, then cover tightly and simmer on low heat for 40 to 50 minutes until the rice and vegetables are perfectly tender.
3264	631	1	Mix the minced beef thoroughly with the grated onions, bell peppers, chilies, and dry spices until a sticky paste forms.|2. Slice open the edge of each pita bread loaf to create a pocket.|3. Spread a generous, even layer of the raw beef mixture inside the bread pocket.|4. Press down firmly on the bread to flatten the meat layer out evenly.|5. Brush both the top and bottom exterior of the bread heavily with melted ghee or oil.|6. Wrap each flatbread sandwich in parchment paper or foil.|7. Bake in a preheated oven at 200°C for 25 to 30 minutes, unwrapping for the last 5 minutes to crisp up the crust.
3300	667	1	Simmer the quandong fruit in water with sugar for 20 minutes until plump, soft, and sweet-tart.|2. Allow the fruit filling to cool completely down to room temperature.|3. Line a pie dish with shortcrust pastry dough.|4. Spoon the quandong fruit mixture into the pastry base.|5. Cover the top with another sheet of pastry, crimping the edges closed and cutting a small steam slit on top.|6. Brush with egg wash and sprinkle a light dusting of sugar over the crust.|7. Bake at 190°C for 35 to 40 minutes until the crust is golden brown and flaky; serve warm.
3265	632	1	Boil the penne pasta until al dente, drain, and set aside.|2. Sauté chopped onions and brown the minced beef, then stir in a spoonful of tomato paste, allspice, salt, and pepper.|3. To make the béchamel, melt butter in a pot, whisk in flour, and gradually pour in warm milk while whisking constantly until thick and smooth; season with nutmeg.|4. Mix a few ladles of the smooth béchamel sauce into the cooked pasta.|5. Layer half of the pasta at the bottom of a greased baking dish, then spread the savory minced beef evenly over it.|6. Top with the remaining pasta, then pour the rest of the thick béchamel sauce smoothly over the entire dish.|7. Bake at 190°C for 40 minutes until bubbling and beautifully golden brown on top.
3266	633	1	Sear the lamb chunks in ghee in a heavy pot until browned, then add chopped onions and cook until soft.|2. Pour in the tomato puree, tomato paste, and a splash of water, then cover and simmer until the lamb is tender.|3. Toss the okra pods and a squeeze of lemon juice directly into the bubbling tomato stew.|4. In a separate small pan, fry the minced garlic and ground coriander in ghee until golden brown.|5. Pour the fragrant fried garlic mixture smoothly into the main stew pot.|6. Simmer uncovered for another 15 to 20 minutes until the okra is tender and the sauce reduces.|7. Serve hot with white rice or flatbread.
3267	634	1	Fry the large amount of sliced onions in oil over medium-high heat, stirring continuously until they turn a very dark brown color (but not burnt).|2. Drain the onions and blend them with a little water into a smooth, dark paste.|3. Pour the dark onion paste back into a pot with fish stock, cumin, and salt, bringing it to a boil.|4. Add the white rice to the dark boiling liquid, cover tightly, and simmer on low heat until the rice is fully cooked and amber-colored.|5. Season the fish fillets with minced garlic, cumin, coriander, salt, and a splash of lemon juice.|6. Dredge the fish lightly in flour and pan-fry in hot oil until crispy on both sides.|7. Mound the dark caramelized rice onto a platter and arrange the crispy fish fillets neatly on top.
3268	635	1	Toss the thin liver strips with half of the minced garlic, cumin, coriander, and a splash of vinegar; let marinate for 15 minutes.|2. Heat a generous amount of oil in a wide skillet over extremely high heat until smoking.|3. Drop the liver strips into the hot pan, spreading them out quickly (do not overcrowd).|4. Stir-fry vigorously for 2 to 3 minutes over high heat until the liver changes color.|5. Toss in the sliced green peppers, chilies, and the remaining minced garlic.|6. Stir-fry for another 2 minutes until the peppers are slightly wilted but still crisp.|7. Turn off the heat, squeeze fresh lime juice over the top, and serve inside warm baguettes or pita bread.
3269	636	1	Mix the semolina, sugar, and coconut flakes together, then rub in the melted ghee thoroughly with your fingers.|2. Stir in the yogurt gently until a thick, uniform paste forms.|3. Press the batter evenly into a greased baking pan, smoothing the surface with wet hands.|4. Score the surface into diamond shapes with a knife and place an almond in the center of each diamond.|5. Bake at 200°C for 25 to 30 minutes until the cake turns a beautiful deep golden brown.|6. While baking, boil sugar and water with lemon juice for 5 minutes, then stir in rose water to make the syrup.|7. Pour the hot syrup evenly over the hot basbousa right as it comes out of the oven; let it cool completely before slicing.
3270	637	1	Arrange the broken pieces of crispy puff pastry at the bottom of a deep baking dish.|2. Scatter the mixed nuts, raisins, and coconut flakes evenly over the pastry layer.|3. Heat the whole milk with sugar and vanilla extract in a pot until boiling.|4. Pour the hot sweet milk over the pastry and nuts, ensuring everything is fully submerged and soaking.|5. Spread a dense layer of heavy cream smoothly over the top surface.|6. Place the dish under the oven broiler/grill for 10 to 15 minutes.|7. Remove when the top is bubbly, deeply caramelized, and golden brown; serve warm.
3271	638	1	Pulse the shredded pastry dough in a food processor, then toss thoroughly with melted ghee until every strand is coated.|2. Press half of the greasy dough firmly into the bottom of a round baking pan to form a tight crust.|3. Spread the thick clotted cream (ashta) evenly over the pastry base, leaving a small border around the edges.|4. Cover the cream completely with the remaining shredded dough, pressing down very gently.|5. Bake at 200°C for 30 to 35 minutes until the edges are golden and crispy.|6. Carefully flip the hot kunafa onto a serving platter.|7. Pour cold sugar syrup over the piping hot pastry, garnish with ground pistachios, and slice.
3272	639	1	Blend flour, semolina, sugar, yeast, baking powder, and warm water together into a thin, bubbly batter; let rest for 15 minutes.|2. Pour ladlefuls of batter onto a hot, ungreased non-stick skillet to form small circles.|3. Cook on one side only (bubbles will form on top and dry out, creating a spongy texture); do not flip.|4. Remove the pancakes and keep them covered under a clean towel so they stay pliable.|5. Place a spoonful of the cinnamon-nut filling in the center of the uncooked side.|6. Fold the pancake in half and pinch the edges firmly together to seal into a crescent shape.|7. Deep-fry or bake the parcels until crispy, then drop immediately into sweet simple syrup and serve.
3273	640	1	Boil the short-grain rice in a cup of water until the water is completely absorbed and the rice is soft.|2. Pour the whole milk and sugar into the pot with the rice, bringing it to a very gentle simmer.|3. Cook on low heat for 20 minutes, stirring frequently so the milk doesn't scorch.|4. Stir in the cornstarch slurry and cook for another 5 minutes until the pudding thickens.|5. Turn off the heat and stir in the ground mastic and a splash of rose water.|6. Ladle the creamy pudding into individual serving bowls.|7. Let cool to room temperature, then chill in the fridge and garnish with nuts before serving cold.
3274	641	1	Whisk the flour, cornstarch, yeast, sugar, and warm water together into a thick, sticky batter.|2. Cover the bowl and let the batter rise in a warm spot for 1 hour until highly bubbly.|3. Heat a generous amount of oil in a deep pot over medium heat.|4. Drop small spoonfuls of the sticky batter into the hot oil (or squeeze through your hand).|5. Fry the balls continuously, rolling them around in the oil until they are uniformly pale gold; remove and drain.|6. Fry them a second time at a slightly higher heat for 2 minutes until incredibly crunchy and deep golden brown.|7. Drop the hot zalabia directly into cold thick syrup, toss to coat, and serve immediately.
3275	642	1	Knead the flour, water, and salt into a soft, highly elastic dough; divide into balls and let rest for 1 hour.|2. Grease a large work surface heavily with melted ghee.|3. Roll and stretch a dough ball by hand until it becomes paper-thin and translucent.|4. Fold the thin sheet into a square, brushing plenty of ghee between each fold.|5. Repeat the process with a second ball, wrapping it around the first square to create dozens of microscopic layers.|6. Flatten the layered pastry package gently into a large round disc and place on a greased baking sheet.|7. Bake at a very high heat (230°C) for 10 to 12 minutes until it puffs up and turns golden; serve hot with honey and cream.
3276	643	1	Whip the firm, chilled ghee and powdered sugar together using an electric mixer until light, white, and fluffy.|2. Gradually fold in the flour by hand until a soft, smooth dough forms (do not over-knead).|3. Refrigerate the dough for 30 minutes to make it easier to handle.|4. Roll the dough into small, smooth balls and arrange them on a baking sheet.|5. Press a single pistachio or clove gently into the center of each ball to slightly flatten it.|6. Bake in a preheated oven at a low temperature (150°C) for exactly 10 to 12 minutes.|7. The cookies should remain completely white and not brown at all; let cool entirely on the tray before moving.
3277	644	1	Mix the flour, sesame seeds, and kahk spices in a bowl, then pour the warm melted ghee over them and blend thoroughly.|2. Stir in the activated yeast liquid, kneading gently until a cohesive dough forms.|3. Pinch off a piece of dough, flatten it, and place a small ball of date paste or a nut piece in the center.|4. Seal the dough completely and roll into a smooth ball, then stamp with a traditional pattern mold.|5. Arrange the patterned cookies on a baking sheet and let rest for 30 minutes.|6. Bake at 180°C for 15 to 20 minutes until the bottoms are pale golden.|7. Cool completely, then dust heavily with powdered sugar right before serving.
3278	645	1	Reserve half a cup of cold milk and pour the rest into a pot with sugar, heating until warm.|2. Whisk the cornstarch into the cold milk until completely dissolved with no lumps.|3. Pour the cornstarch mixture slowly into the warm milk pot, whisking continuously.|4. Bring the pudding to a gentle boil on medium-low heat, stirring constantly until it thickens smoothly.|5. Turn off the heat and stir in the orange blossom water.|6. Pour the hot pudding into small dessert bowls or glasses.|7. Allow to cool to room temperature, refrigerate for 2 hours, and garnish with crushed pistachios before serving cold.
3279	646	1	Place a handful of dried hibiscus flowers into a large pot filled with water.|2. Bring the water to a rolling boil over medium-high heat.|3. Lower the heat and let it simmer for 10 to 15 minutes until the liquid turns a rich, opaque dark red.|4. Stir in a generous amount of sugar until it dissolves completely.|5. Strain the tea through a fine sieve into a pitcher, discarding the spent flower petals.|6. Serve hot in teacups, or chill thoroughly in the refrigerator and serve over ice cubes for a refreshing summer drink.
3280	647	1	Add 1 to 2 teaspoons of loose black tea leaves into a traditional glass or small teapot.|2. Pour boiling water directly over the tea leaves.|3. Let the tea steep for 3 to 5 minutes to create a strong, dark amber brew.|4. Take a handful of fresh spearmint sprigs, bruise the leaves gently with your fingers to release oils, and drop them into the glass.|5. Add sugar according to your personal preference (traditionally served quite sweet).|6. Let sit for 1 minute so the mint flavor infuses into the hot black tea, and serve.
3281	648	1	Pour the milk and sugar into a pot, reserving a small amount of cold milk to dissolve the powder.|2. Whisk the sahlab powder or cornstarch into the cold milk until completely smooth.|3. Pour the slurry into the pot of warm milk over medium-low heat.|4. Whisk continuously as the mixture heats up to prevent lumps and sticking.|5. Simmer gently for 2 to 3 minutes until the drink thickens into a rich, velvety, coat-the-spoon consistency.|6. Pour the hot, thick liquid into mugs.|7. Garnish the surface heavily with shredded coconut, raisins, crushed nuts, and a dusting of cinnamon; serve hot with a spoon.
3282	649	1	In a high-speed blender, combine the fine rice flour, sugar, and coconut milk powder.|2. Pour in the cold whole milk, a splash of water, and vanilla extract.|3. Blend on high speed for 1 to 2 minutes until the sugar dissolves and the drink becomes smooth and frothy.|4. Taste and adjust the sweetness or coconut flavor if desired.|5. Pour the mixture through a very fine cheesecloth or sieve to catch any residual rice grit if necessary.|6. Chill thoroughly in the refrigerator.|7. Pour into glasses and serve ice-cold.
3283	650	1	Clean and peel the hard outer layer of the fresh sugarcane stalks.|2. Run the raw stalks through a specialized heavy-duty electric crushing mill to extract the sweet juice.|3. The resulting juice emerges with a cloudy, pale green or golden color and a light natural froth.|4. Filter the juice immediately through a fine mesh strainer to remove any remaining cane fibers.|5. Pour the fresh sugarcane juice immediately into large glasses packed with ice cubes.|6. Drink immediately while ice-cold (sugarcane juice oxidizes quickly and changes color if left out).
3284	651	1	Dredge the chicken breasts in flour, dip in beaten eggs, and coat thoroughly with breadcrumbs.|2. Shallow-fry the crumbed chicken in hot oil until golden brown and crispy on both sides, then drain.|3. Place the fried schnitzels onto a baking tray.|4. Lay a slice of ham flat across each chicken schnitzel.|5. Spoon a generous amount of Napolitana sauce over the ham.|6. Smother the top with a handful of the grated cheese mixture.|7. Bake or grill in a hot oven until the cheese is bubbling, melted, and golden brown; serve with chips and salad.
3285	652	1	Brown the minced beef and chopped onions in a pan until cooked through.|2. Stir in the beef stock, Worcestershire sauce, and tomato paste, bringing it to a simmer.|3. Pour in the cornstarch slurry and stir until the meat gravy becomes very thick; let it cool completely.|4. Line individual pie tins with the shortcrust pastry sheets.|5. Spoon the cooled, thick meat filling into the pastry bases.|6. Cover the tops with puff pastry sheets, pinching the edges together tightly to seal the pie shut.|7. Brush the puff pastry lids with egg wash and bake at 200°C for 25 minutes until puffed and golden brown. Serve with tomato sauce (ketchup).
3286	653	1	Pat the Barramundi skin completely dry with a paper towel and score it lightly with a sharp knife.|2. Rub ground lemon myrtle, sea salt, and white pepper onto both sides of the fish fillets.|3. Heat olive oil and a small dollop of butter in a non-stick skillet over medium-high heat.|4. Place the fish fillets skin-side down into the hot pan, pressing down gently with a spatula.|5. Cook for 4 to 5 minutes until the skin is exceptionally crispy and golden.|6. Carefully flip the fillet over, add a little more butter and minced garlic to the pan, and baste the fish for 2 minutes.|7. Remove from heat and serve hot with a squeeze of fresh lemon juice.
3287	654	1	Make small, deep incisions all over the leg of lamb using a sharp knife.|2. Stuff a sliver of garlic and a small cluster of rosemary leaves into each incision.|3. Rub the entire exterior of the lamb with olive oil, sea salt, and coarsely cracked black pepper.|4. Place the lamb on a roasting rack in a deep tray and roast at 180°C for 1.5 to 2 hours depending on weight.|5. To make the sauce, finely chop mint leaves and mix them with a splash of hot water, sugar, and white vinegar.|6. Remove the lamb from the oven and let it rest wrapped in foil for 15 minutes before carving.|7. Slice thin and serve hot alongside roasted potatoes, pumpkin, and the tangy mint sauce.
3288	655	1	Mix ground wattleseed, crushed pepperberries, and sea salt together to form a spice rub.|2. Coat the kangaroo fillets evenly with the spice rub and drizzle lightly with olive oil.|3. Heat a heavy cast-iron skillet over high heat until smoking hot.|4. Sear the kangaroo fillets quickly for about 2 to 3 minutes on each side (do not overcook, as kangaroo is very lean and dries out easily).|5. Remove the meat from the pan and let it rest on a warm plate for 5 minutes to keep it tender.|6. Deglaze the hot pan with a splash of red wine and a spoonful of plum jam, simmering until it forms a glossy reduction sauce.|7. Slice the medium-rare kangaroo loin thinly and drizzle with the warm pan reduction.
3289	656	1	Heat a flat barbecue plate or griddle pan over medium-high heat with a little oil.|2. Place the sliced onions onto the hot plate, grilling and tossing until soft, sweet, and caramelized.|3. Add the beef or pork sausages to the grill, turning regularly until cooked through and nicely browned on the outside.|4. Lay a single slice of white sandwich bread flat onto a plate or paper napkin.|5. Place a hot grilled sausage diagonally across the center of the bread slice.|6. Top the sausage generously with a spoonful of the hot caramelized onions.|7. Drizzle tomato or barbecue sauce directly down the center and fold the bread edges up to hold it.
3290	657	1	Using a sharp knife, slice a deep, horizontal pocket into the side of the thick steak fillet.|2. Gently slide 2 to 3 fresh raw oysters into the steak pocket.|3. Seal the opening of the meat tightly using toothpicks so the oysters don't slip out during cooking.|4. Season both sides of the steak generously with salt, black pepper, and a touch of garlic powder.|5. Sear the steak in a hot skillet with butter for 3 to 4 minutes on each side until cooked to medium-rare or medium.|6. Remove the steak and rest it, allowing the residual heat to perfectly poach the oysters inside.|7. Remove the toothpicks before serving with pan juices.
3291	658	1	Cut the scored squid tubes into bite-sized rectangular pieces or rings.|2. Mix the cornstarch, sea salt flakes, and crushed peppercorns together in a large bowl.|3. Toss the squid pieces thoroughly into the seasoned flour mixture, shaking off any excess.|4. Heat a deep pan of oil to a high temperature (around 190°C).|5. Flash-fry the squid in small batches for just 1 to 1.5 minutes until light golden and crisp (overcooking makes it rubbery).|6. Drain quickly on paper towels.|7. Toss with fresh chili and spring onion slices, and serve hot with garlic aioli.
3292	659	1	Roast the diced pumpkin, onion, and garlic in an oven at 200°C until soft and slightly caramelized.|2. Transfer the roasted vegetables into a pot, pour in the stock, and bring to a simmer for 10 minutes.|3. Use an immersion blender to puree the soup until entirely smooth and velvety.|4. Stir in a splash of heavy cream and a tiny pinch of nutmeg; keep warm.|5. For the bread, mix self-rising flour, a pinch of salt, water, and milk to form a soft, rustic dough.|6. Bake the dough loaf in a greased tin or cast-iron pot until crusty and hollow when tapped.|7. Serve a hot bowl of soup accompanied by thick slices of the warm bread.
3293	660	1	Mix the minced meat, breadcrumbs, egg, garlic powder, onion powder, salt, and pepper in a bowl.|2. Roll the mixture into small, uniform bite-sized balls.|3. Pan-fry the meatballs in a little oil until browned on all sides, then remove.|4. In the same pan, combine the chopped plums, barbecue sauce, and Worcestershire sauce, simmering until smooth and syrupy.|5. Return the browned meatballs to the bubbling plum sauce mixture.|6. Coat them evenly, lower the heat, and simmer for 10 minutes until the meatballs are cooked through.|7. Serve hot over rice or mashed potatoes.
3294	661	1	Whip egg whites in a clean glass bowl until stiff peaks form.|2. Gradually add caster sugar one tablespoon at a time while beating at high speed until glossy and thick.|3. Fold in the cornstarch, white vinegar, and vanilla extract very gently using a spatula.|4. Mound the glossy meringue onto a baking sheet lined with parchment paper, shaping it into a high circle with a flat top.|5. Bake at a very low temperature (120°C) for 1.5 hours, then turn off the oven and let it cool completely inside with the door closed.|6. Carefully remove the cooled meringue base and place it onto a platter.|7. Smother the top with whipped cream and decorate generously with passionfruit pulp and fresh fruit slices.
3295	662	1	Cut the vanilla sponge cake neatly into uniform 5cm squares.|2. Whisk the icing sugar, cocoa powder, melted butter, and boiling water in a deep bowl to form a smooth chocolate icing glaze.|3. Spread a large batch of desiccated coconut flakes into a shallow wide dish.|4. Using a fork, dip a sponge cake square completely into the warm chocolate icing until coated.|5. Lift it out, allowing any excess chocolate glaze to drip off cleanly.|6. Roll the chocolate-coated square immediately in the desiccated coconut until covered on all sides.|7. Place on a wire rack to set before serving.
3296	663	1	Mix the rolled oats, plain flour, sugar, and coconut flakes together in a large bowl.|2. Melt the butter and golden syrup together in a small saucepan over medium heat.|3. Dissolve baking soda in boiling water, then stir it into the hot butter syrup (it will froth dramatically).|4. Pour the foaming liquid over the dry oat mixture, stirring thoroughly to form a sticky dough.|5. Roll tablespoons of dough into balls and arrange them spaced apart on a baking sheet.|6. Flatten each ball slightly with the back of a fork.|7. Bake at 160°C for 12 to 15 minutes until deep golden brown; let cool on the tray to crisp up.
3297	664	1	Combine golden syrup, brown sugar, water, and a knob of butter in a wide saucepan, bringing it to a boil.|2. In a bowl, rub butter into self-rising flour, then add milk to form a soft, pliable dough.|3. Roll the dough into small walnut-sized balls.|4. Drop the dough balls carefully into the boiling golden syrup sauce.|5. Cover the saucepan tightly with a lid and reduce the heat to a low simmer.|6. Cook undisturbed for 15 minutes until the dumplings double in size and become fluffy.|7. Serve hot, spooning plenty of the thick caramel syrup sauce over the dumplings along with ice cream.
3298	665	1	Bake two puff pastry sheets flat under a wire rack until completely golden and crispy; set aside.|2. Boil milk, cream, sugar, and vanilla extract in a pot.|3. Whisk custard powder with water, stir it into the boiling milk, and cook until it turns extremely thick and smooth.|4. Place one sheet of baked pastry at the bottom of a rectangular cake tin.|5. Pour the hot, thick vanilla custard smoothly over the pastry base.|6. Top with the second pastry sheet, pressing down lightly to seal.|7. Mix icing sugar with passionfruit pulp and spread it over the top pastry layer; chill in the fridge overnight before slicing.
3299	666	1	Spread a generous, thick layer of raspberry jam across the bottom of the baked, cooled tart shell.|2. Prepare the pink topping by melting marshmallows with a drop of red food coloring or whipping up a dense pink icing.|3. Pipe or spread the pink marshmallow cream in two parallel strips over the jam layer, leaving a strip of jam visible in the middle.|4. Sprinkle a strip of desiccated coconut flakes heavily down the center of the pink cream.|5. Let it set completely in the refrigerator for 2 hours.|6. Slice neatly and serve cold.
3301	668	1	Combine the puffed rice cereal, icing sugar, cocoa powder, and desiccated coconut in a large bowl.|2. Melt the coconut oil gently in a small saucepan over low heat.|3. Pour the melted coconut oil over the dry ingredients, stirring thoroughly until all the cereal is coated.|4. Spoon the sticky chocolate mixture into paper cupcake liners arranged in a muffin tray.|5. Press down lightly with the back of a spoon to compact the treats.|6. Place the tray into the refrigerator for at least 1 hour.|7. Serve chilled directly from the paper liners.
3302	669	1	Boil sugar and golden syrup together until it reaches a dark amber color.|2. Stir in baking soda, causing the mixture to foam up wildly, then pour onto paper and let cool until brittle.|3. Crush the hardened honeycomb into small shards.|4. Whip the heavy cream until stiff peaks form.|5. Gently fold the crunchy honeycomb shards into the whipped cream.|6. Pipe the honeycomb cream filling generously into both ends of the crispy pastry shells.|7. Serve immediately so the honeycomb retains its crisp texture.
3303	670	1	Mix the crushed biscuits with melted butter and press firmly into the bottom of a square tin; chill until firm.|2. Dissolve gelatin powder in hot water, then whisk it together with condensed milk and lemon juice.|3. Pour the white condensed milk mixture over the biscuit base and refrigerate for 1 hour until set.|4. Prepare the red packet jelly according to instructions, letting it cool down completely to room temperature.|5. Carefully pour the liquid red jelly over the set white layer.|6. Return the tin to the refrigerator for 3 hours until the top jelly layer is completely firm.|7. Slice into neat squares using a hot knife and serve cold.
3304	671	1	Pull a double shot of rich espresso into a ceramic coffee cup using an espresso machine.|2. Steam fresh whole milk in a stainless steel pitcher until it reaches approximately 65°C.|3. Incorporate the steam to create a velvety texture with tiny microfoam bubbles (avoid creating thick, frothy foam).|4. Tap and swirl the milk pitcher to ensure the liquid and microfoam are completely integrated.|5. Pour the velvety milk steadily into the center of the double espresso shot.|6. Finish with a thin, silky layer of microfoam on the surface and serve hot.
3305	672	1	Take a clean highball or swizzle glass.|2. Dash 4 to 6 drops of Angostura bitters inside, swirling the liquid to coat the entire inner surface of the glass.|3. Pack the glass to the brim with fresh ice cubes.|4. Pour in a splash of sweet lime juice cordial over the ice.|5. Top up the glass slowly with sparkling lemonade soda.|6. Garnish with fresh lemon and lime wheels.|7. Stir gently with a straw to blend the ingredients, turning the drink a beautiful light pink color.
3306	673	1	Fill a traditional tin pot (a billy) with water and place it directly over an open campfire until boiling.|2. Toss a generous handful of loose black tea leaves directly into the boiling water.|3. Drop one fresh, clean eucalyptus leaf into the water to impart a distinct bush fragrance.|4. Remove the billy from the fire and let the tea steep for 5 minutes.|5. To settle the loose leaves, swing the billy pot in a dramatic full vertical circle by its handle three times.|6. The centrifugal force forces the leaves down to the bottom of the tin.|7. Pour carefully into tin mugs and enjoy hot.
3307	674	1	Add 3 heaped tablespoons of chocolate malt powder into a tall glass.|2. Pour in a small splash of hot water, stirring rapidly to dissolve the powder into a thick syrup.|3. Fill the glass with cold whole milk, stirring until completely mixed.|4. Drop in a handful of ice cubes to chill the beverage thoroughly.|5. Heap another 2 large tablespoons of dry chocolate malt powder directly onto the surface of the cold milk.|6. Do not stir the top layer; allow it to float in a thick, crunchy mound.|7. Serve immediately with a straw and spoon.
3308	675	1	Simmer grated fresh ginger, lemon juice, sugar, and water in a saucepan for 15 minutes to create a hot, spicy ginger syrup.|2. Strain the syrup through a fine sieve to remove all the fibrous ginger pulp; let it cool completely.|3. Pour a generous portion of the cold ginger syrup into the bottom of a glass.|4. Pack the glass with ice cubes.|5. Top up with crisp, ice-cold sparkling mineral water or club soda.|6. Stir gently to combine the syrup with the carbonation.|7. Garnish with a slice of lime and serve ice-cold.
3309	676	1	Dig a deep pit in the ground and light a large wood fire inside it, placing volcanic stones over the wood to heat for 3 hours.|2. Once the wood burns down to white-hot coals and the stones are glowing, remove any unburnt wood.|3. Season the meat heavily with salt and place it into large, clean wire baskets lined with wet cabbage leaves.|4. Arrange the kūmara, potatoes, and pumpkins neatly in a separate basket on top of the meat.|5. Lower the wire food baskets carefully directly onto the white-hot stones.|6. Cover the baskets immediately with damp canvas sheets or burlap bags to capture the steam.|7. Mound the dug-out earth over the entire pit to seal it completely, leaving it to slow-steam underground for 3 to 4 hours.
3310	677	1	Preheat the oven to 180°C and pat the lamb leg completely dry using a paper towel.|2. Make small, deep slits all over the surface of the meat using a sharp paring knife.|3. Stuff a piece of garlic and a small cluster of rosemary leaves firmly into each slit.|4. Rub olive oil, sea salt, and black pepper generously over the entire leg.|5. Place the lamb into a roasting tray and bake for 1.5 to 2 hours depending on your desired level of doneness.|6. Remove the lamb from the oven and let it rest loosely under aluminum foil for 15 minutes before carving.|7. Whisk the leftover pan drippings with flour and beef stock over medium heat to form a rich gravy to serve alongside the sliced lamb.
3311	678	1	Sauté the onions in a pan until soft, then add the minced beef and brown it thoroughly.|2. Pour in the beef stock, Worcester sauce, and tomato paste, bringing the mixture to a boil.|3. Stir in the cornstarch dissolved in water, simmering until the gravy becomes incredibly thick and glossy; let cool.|4. Line single-serve pie molds with the shortcrust pastry sheets.|5. Spoon the cooled minced beef filling into the pastry bases, filling them three-quarters full.|6. Place a generous handful of cheddar cheese directly on top of the hot meat mixture.|7. Cover with a puff pastry sheet, crimp the edges tightly to seal, brush with egg wash, and bake at 200°C for 25 minutes.
3312	679	1	Rinse the fresh whitebait gently and drain them thoroughly on paper towels.|2. Whisk the egg whites in a clean bowl until light and frothy, then fold in the egg yolks.|3. Gently stir the whitebait directly into the beaten eggs, seasoning with salt and white pepper.|4. Melt a generous knob of butter in a non-stick skillet over medium-high heat.|5. Spoon small dollops of the whitebait mixture into the sizzling pan, flattening them into disc-shaped fritters.|6. Fry for just 1 to 2 minutes on each side until the egg is cooked through and lightly golden.|7. Serve immediately inside buttered white bread with a heavy squeeze of fresh lemon juice.
3313	680	1	Melt the butter in a large, deep pot over medium heat and sauté the chopped shallots and minced garlic until translucent.|2. Pour the dry white wine into the pot and bring it to a rapid boil.|3. Toss all the scrubbed green-lipped mussels into the boiling wine and cover the pot tightly with a lid.|4. Steam for 4 to 5 minutes, shaking the pot occasionally, until all the mussel shells pop open wide.|5. Remove the open mussels with a slotted spoon and place them into a serving bowl, discarding any that stayed shut.|6. Pour the heavy cream into the remaining hot pan juices, simmering rapidly until the liquid thickens slightly.|7. Stir in the fresh parsley, then pour the hot cream sauce directly over the open mussels.
3314	681	1	Place the pork bones into a very large pot, cover completely with water, and add a generous handful of salt.|2. Bring to a boil, then lower the heat and simmer gently for 1.5 to 2 hours until the pork meat is falling off the bones.|3. Add the chunked kūmara, potatoes, and carrots into the bubbling pork broth.|4. Mix flour, a pinch of salt, and a splash of water in a bowl to form a stiff dough, rolling them into small balls (doughboys).|5. Drop the doughboys directly into the boiling soup on top of the vegetables.|6. Pack a thick layer of fresh watercress or puha over the very top of the pot.|7. Cover with a lid and simmer for another 20 to 30 minutes until the root vegetables are soft and the dumplings are cooked through.
3315	682	1	Combine the grated cheddar cheese, evaporated milk, French onion soup mix, and chopped onion in a saucepan.|2. Stir continuously over medium-low heat until the cheese melts completely and creates a thick, uniform paste; let cool.|3. Lay a slice of white sandwich bread completely flat on a cutting board.|4. Spread a generous layer of the cooled cheese paste evenly across the bread slice.|5. Roll the bread up tightly from one side to the other, creating a log or cylinder shape.|6. Brush the exterior of the bread roll heavily with melted butter.|7. Place under a hot oven broiler or onto a flat griddle pan, turning regularly until the outside is golden-brown and crispy and the cheese inside is molten.
3316	683	1	Sauté the chopped bacon and onions in a pan until the bacon is lightly cooked but not crispy; let cool.|2. Line a pie dish with a sheet of puff pastry.|3. Scatter the cooked bacon and onion mixture evenly across the bottom pastry base.|4. Crack the eggs directly into the pie case one by one, keeping the yolks completely whole and spaced out.|5. Season the top gently with salt and black pepper.|6. Place another sheet of puff pastry over the top, crimping the edges together tightly to trap the eggs.|7. Brush the top crust with milk or egg wash, cut a small vent hole, and bake at 200°C for 35 to 40 minutes until puffed and golden.
3317	684	1	Mix the breadcrumbs, chopped onion, fresh herbs, honey, and a splash of milk in a bowl to create a dense stuffing.|2. Lay the deboned leg of lamb flat on a clean surface, skin-side down.|3. Pack the herb stuffing tightly into the central cavity where the bone used to be.|4. Roll the meat up securely around the stuffing mixture.|5. Tie the rolled lamb tightly at regular intervals using kitchen twine to hold its shape during cooking.|6. Rub the outside with salt and oil, then place into a deep roasting pan.|7. Roast at 180°C for 1.5 to 2 hours until the lamb is fully cooked, then slice across into rounds to show the stuffing pattern.
3318	685	1	Remove the pāua from its iridescent shell, clean it thoroughly, and pulse it in a food processor until finely minced.|2. In a bowl, combine the minced pāua, grated onion, beaten egg, flour, and a splash of cream.|3. Mix the ingredients thoroughly until a thick, uniform batter forms.|4. Melt a generous amount of butter in a skillet over medium-high heat.|5. Spoon the dark batter into the hot pan, pressing down slightly to form uniform patties.|6. Fry for 2 minutes on each side (do not overcook, or the pāua will turn rubbery).|7. Serve hot with a side of tartare sauce or fresh salad.
3319	686	1	Whip the egg whites in a perfectly clean bowl until stiff peaks form.|2. Add the caster sugar slowly, one tablespoon at a time, beating constantly until the meringue is thick, glossy, and sugar crystals dissolve.|3. Gently fold in the white vinegar, cornstarch, and vanilla extract using a metal spoon.|4. Shape the meringue into a high, neat circle on a baking sheet lined with baking paper.|5. Bake at 120°C for 1 hour and 15 minutes, then turn off the oven and let it cool completely inside with the door propped open.|6. Transfer the cold meringue shell onto a serving platter.|7. Pile whipped heavy cream smoothly over the top and decorate with fresh kiwifruit slices.
3320	687	1	Crush the malt biscuits in a food processor until they form fine crumbs, leaving a few small chunks for texture.|2. Chop the firm marshmallow candies into bite-sized pieces and toss them with the biscuit crumbs in a large bowl.|3. Pour the melted butter and sweetened condensed milk directly into the dry mixture.|4. Stir everything together thoroughly until a thick, sticky dough forms.|5. Shape the dough using your hands into a long, uniform cylinder log on a piece of parchment paper.|6. Roll the log heavily in a generous bed of desiccated coconut flakes until completely coated.|7. Wrap the log tightly in cling wrap and refrigerate for 4 hours before slicing into rounds.
3321	688	1	Combine the sugar and golden syrup in a heavy saucepan over medium heat, stirring until the sugar dissolves.|2. Bring the syrup to a boil and let it cook without stirring for 3 minutes until it turns a deep amber color.|3. Remove the pan from the heat and immediately add the baking soda, whisking rapidly.|4. Watch the mixture foam up wildly into a golden cloud, then pour it instantly onto a greased baking sheet to cool.|5. Once the hokey pokey toffee has hardened completely, crush it into small, crunchy shards using a rolling pin.|6. Soften your vanilla ice cream slightly in a large bowl.|7. Fold the crunchy honeycomb shards quickly into the ice cream, then return it to the freezer to firm up before serving.
3322	689	1	Cream the butter and sugar together, then fold in the flour, baking powder, and ground ginger.|2. Press the firm dough evenly into the bottom of a greased square baking tin.|3. Bake at 180°C for 20 minutes until the base turns pale golden and firm.|4. While hot, melt butter, golden syrup, icing sugar, and extra ground ginger together in a saucepan to create the icing.|5. Whisk the icing until smooth, glossy, and intensely spicy.|6. Pour the warm ginger icing directly over the baked base while it is still warm from the oven.|7. Let the slice cool completely in the tin, then cut into small, rich squares.
3323	690	1	Mix flour, sugar, butter, and egg yolks together to form a soft shortbread dough.|2. Press the dough into a lined slice tin and bake at 180°C for 15 minutes until set.|3. Spread a generous, even layer of sweet raspberry jam across the warm shortbread base.|4. Whip the egg whites and caster sugar together in a clean bowl until stiff, glossy peaks form.|5. Gently fold the desiccated coconut flakes directly into the whipped meringue.|6. Spread the coconut meringue smoothly over the jam layer, smoothing it out to the edges.|7. Return to the oven and bake for another 15 minutes until the meringue top is crisp and lightly toasted; cool before cutting.
3324	691	1	Cream the softened butter and sugar together until light and fluffy.|2. Sift in the flour and cocoa powder, mixing gently to form a thick chocolate dough.|3. Fold the plain cornflakes into the dough by hand, crushing them slightly so they distribute evenly.|4. Spoon mounds of the dough onto a baking sheet, leaving space between them.|5. Bake at 180°C for 12 to 15 minutes until set; let cool completely on a wire rack.|6. Spread a dollop of rich chocolate icing smoothly over the top of each cooled biscuit.|7. Press a single walnut half firmly into the center of the wet icing before it sets.
3325	692	1	Arrange the sliced fresh feijoa pulp into the bottom of an ovenproof baking dish.|2. Sprinkle a little white sugar over the fruit layer if they are quite tart.|3. In a separate bowl, mix the rolled oats, flour, and brown sugar together.|4. Rub the chilled, cubed butter into the oat mixture using your fingertips until it resembles coarse breadcrumbs.|5. Scatter the oat crumble mixture evenly over the feijoa fruit layer.|6. Bake at 190°C for 30 to 35 minutes.|7. Remove from the oven when the fruit underneath is bubbling and the oat crust is deep golden brown; serve warm with ice cream.
3326	693	1	Bake two puff pastry sheets flat in the oven until deep golden and completely crisp; let cool.|2. Bring the milk, cream, sugar, and vanilla extract to a boil in a heavy pot.|3. Whisk the custard powder and cornstarch with cold water, pour into the boiling milk, and stir vigorously until extremely thick.|4. Place one sheet of baked pastry into the bottom of a deep square tin.|5. Pour the hot, thick custard smoothly over the pastry base, smoothing the top flat.|6. Place the second sheet of pastry carefully on top of the custard layer.|7. Mix icing sugar with water to create a white glaze, spread it over the top pastry layer, and chill overnight before slicing with a serrated knife.
3327	694	1	Melt the butter, sugar, and golden syrup together in a saucepan until the sugar dissolves.|2. Stir in the flour and ground ginger until a smooth, thin batter forms.|3. Drop small spoonfuls of the batter far apart onto a lined baking sheet (they will spread out very flat).|4. Bake at 180°C for 8 to 10 minutes until bubbly and dark golden lace-like discs form.|5. Let cool for 1 minute on the tray, then quickly lift and wrap the warm, pliable cookies around the handle of a wooden spoon to form tubes.|6. Allow the tubes to cool completely until they become rigid and exceptionally brittle.|7. Pipe freshly whipped cream into both ends of the ginger tubes right before serving so they stay crunchy.
3328	695	1	Roll your risen yeast dough out into a large, flat rectangle on a floured surface.|2. Spread a generous layer of softened butter completely across the surface of the dough.|3. Sprinkle brown sugar, ground cinnamon, and the mixed dried fruit evenly over the butter.|4. Roll the dough up tightly into a long log starting from the long edge.|5. Slice the log into uniform 3cm rounds and place them cut-side down tightly next to each other in a baking tin.|6. Let the buns rise for 30 minutes until they crowd the pan, then bake at 180°C for 25 minutes.|7. Boil sugar and water to make a quick syrup, and brush it heavily over the hot buns as soon as they leave the oven.
3329	696	1	Squeeze fresh lemons to extract clean juice and strain out any pulp or seeds.|2. Mix equal parts sugar and water in a saucepan, heating until dissolved to create a simple syrup.|3. Pour a splash of the fresh lemon juice and a shot of the sugar syrup into the bottom of a glass.|4. Top up the glass with ice-cold carbonated sparkling mineral water.|5. Stir gently to integrate the syrup without losing the carbonation.|6. Adjust the sweetness to taste (the commercial version has a distinct sweet, mild citrus profile).|7. Serve ice-cold with a slice of lemon.
3330	697	1	Grind coffee beans fine and extract a strong double shot of espresso into a ceramic cup using an espresso machine.|2. Pour cold whole milk into a stainless steel milk jug.|3. Steam the milk using the steam wand, keeping the tip near the surface to introduce air gently without making large bubbles.|4. Swirl the milk jug continuously to integrate the liquid and the foam into a glossy, wet-paint consistency (microfoam).|5. Tap the jug firmly on the counter to pop any remaining stray bubbles.|6. Pour the velvety microfoamed milk steadily into the center of the espresso shot from a slight height, dropping the jug close at the end to create a clean white circle on top.
3331	698	1	Place the lime wedges, fresh mint leaves, and sugar syrup into the bottom of a sturdy highball glass.|2. Muddle the ingredients together gently using a cocktail muddler to release the lime juice and mint oils.|3. Add the fresh feijoa pulp directly into the glass, muddling briefly to incorporate.|4. Fill the glass to the brim with crushed ice cubes.|5. Pour a generous shot of white rum over the ice.|6. Top up the remaining space in the glass with sparkling soda water.|7. Stir from the bottom up using a long spoon to distribute the fruit pulp evenly, and serve cold.
3332	699	1	Select clean, whole kawakawa leaves (traditionally, leaves with holes chewed by insects are preferred as they indicate a healthy tree).|2. Rinse the leaves gently under cold water.|3. Place 2 to 3 leaves directly into a teapot or large mug.|4. Pour boiling hot water over the leaves.|5. Let the herbal tea steep undisturbed for 5 to 10 minutes to allow the peppery, earthy notes to infuse fully.|6. Remove the leaves from the water.|7. Stir in a spoonful of native Mānuka honey to balance the natural spice, and serve hot.
3333	700	1	Drizzle a generous amount of golden syrup around the inside walls of a tall glass for decoration.|2. Place 3 large scoops of ice cream into a high-speed blender.|3. Pour in a splash of cold whole milk and a tablespoon of golden syrup.|4. Blend on high speed for 15 seconds until thick, smooth, and creamy.|5. Pour the thick milkshake carefully into the decorated glass.|6. Top the shake with a heavy mountain of crushed homemade hokey pokey honeycomb pieces.|7. Serve immediately with a wide straw and a spoon to catch the crunchy toffee.
3334	701	1	Place the cubed raw fish into a glass bowl and pour the fresh lime juice over it until fully submerged.|2. Cover and let it chill in the refrigerator for 2 to 3 hours until the fish turns opaque and "cooks" in the acid.|3. Drain off most of the excess lime juice from the fish.|4. Pour the fresh, thick coconut cream over the cured fish cubes.|5. Toss in the finely diced onions, tomatoes, spring onions, and chopped chilies.|6. Season generously with salt to balance the richness of the coconut cream.|7. Serve chilled, traditionally presented inside a halved coconut shell.
3335	702	1	Dig a deep pit in the earth, line it with heavy firewood and volcanic stones, and light it to heat the stones for 2 hours.|2. Marinate the chicken and pork pieces with mashed garlic, ginger, onions, soy sauce, and salt.|3. Wrap the seasoned meats tightly in clean aluminum foil or directly inside damp banana leaves.|4. Secure the leaf parcels firmly using woven coconut fronds to prevent earth from entering.|5. Clear the unburnt wood from the pit so only the glowing, white-hot stones remain at the bottom.|6. Lay the meat parcels carefully directly onto the hot stones and cover them with extra banana leaves.|7. Buried the entire pit completely under a thick mound of soil to trap the smoke, letting it slow-cook for 3 hours.
3336	703	1	Wash the taro leaves thoroughly, removing the tough central veins and stems.|2. Bring a large pot of salted water to a boil and boil the taro leaves for 10 minutes to remove any bitterness; drain completely.|3. In a separate pot, heat the fresh coconut cream along with the chopped onion, minced garlic, and ginger.|4. Add the boiled taro leaves into the warm coconut cream mixture.|5. Simmer on low heat for 15 to 20 minutes until the leaves become exceptionally soft and creamy.|6. Stir gently, ensuring the leaves absorb the aromatics without completely disintegrating.|7. Season with a pinch of salt and hot chilies before serving warm with boiled cassava.
3337	704	1	Heat oil in a heavy-based pot and fry the cumin seeds, sliced onions, minced garlic, and ginger until soft.|2. Stir in the curry powder and turmeric, toasting the spices for 1 minute until highly fragrant.|3. Add the chopped tomatoes and a splash of water, cooking until a thick masala paste forms.|4. Pour the fresh coconut milk into the spiced paste, stirring well, and bring it to a gentle simmer.|5. Season the liquid with salt to taste.|6. Gently lower the raw fish chunks into the bubbling curry sauce.|7. Cover and simmer on low heat for 8 to 10 minutes until the fish is flaky and cooked through; serve hot over white rice.
3338	705	1	Squeeze any excess moisture or starch out of the finely grated raw cassava using a clean cloth.|2. Mix the grated cassava thoroughly with a small splash of coconut cream and sugar to form a thick, heavy paste.|3. Pass a clean banana leaf over an open flame quickly to soften it and make it pliable.|4. Place a large scoop of the cassava paste into the center of the softened banana leaf.|5. Fold the leaf tightly over the paste to form a neat, secure rectangular parcel.|6. Steam the parcels in a large pot or bake them in a lovo earth oven for 45 minutes until the cassava sets into a firm pudding texture.|7. Unwrap the warm parcel and drench it in extra hot, fresh coconut cream before eating.
3339	706	1	Boil the cleaned octopus in water with a squeeze of lemon juice for 30 minutes until completely tender, then cut into bite-sized pieces.|2. Sauté the minced onions, garlic, ginger, and hot chilies in a pot until golden brown.|3. Add the curry powder and garam masala, stirring rapidly to toast the spices without burning them.|4. Toss the tenderized octopus pieces into the spiced pan, coating them thoroughly in the masala.|5. Pour in the coconut milk, stirring to lift any browned bits from the bottom of the pot.|6. Bring to a boil, then turn the heat down to low and simmer uncovered for 15 minutes until the sauce reduces into a thick gravy.|7. Serve hot alongside boiled taro roots.
3340	707	1	Slice the eggplants in half lengthwise and carefully scoop out some of the inner flesh to create a hollow boat shape.|2. Finely chop the scooped eggplant flesh and mix it with the minced fish, diced onions, chilies, salt, and pepper.|3. Stuff the seasoned fish mixture tightly back into the hollowed eggplant halves.|4. Place the stuffed eggplants upright and side-by-side inside a wide, flat saucepan.|5. Pour fresh coconut cream carefully around the sides of the eggplants until it reaches halfway up.|6. Bring the liquid to a simmer, cover the pan tightly with a lid, and cook on low heat for 20 to 25 minutes.|7. Remove the lid when the eggplant is completely tender and the fish filling is cooked through, serving the rich bottom sauce over the top.
3341	708	1	Heat oil in a heavy pot and fry the mustard seeds, cumin seeds, and fresh curry leaves until they crackle loudly.|2. Add the chopped onions, garlic, and ginger, stir-frying until dark golden brown.|3. Mix the curry powder and chili powder with a tiny splash of water to form a paste, then stir it into the pot.|4. Add the lamb chops into the hot spiced paste, searing the meat well on all sides to lock in the juices.|5. Turn the heat down to low, cover the pot tightly, and let the lamb cook slowly in its own juices for 45 minutes.|6. Add a small cup of water if the curry becomes too dry, continuing to simmer until the lamb is meltingly tender.|7. Serve hot with freshly patted roti or white rice.
3342	709	1	Make a few shallow cuts across the thickest part of the fish skin and season the entire fish with salt.|2. Shallow-fry the whole fish in hot oil until the skin is perfectly crispy and golden brown on both sides; remove and set aside.|3. In a separate wide pan, combine the thick coconut cream, sliced onion rings, and chopped tomatoes.|4. Bring the coconut cream mixture to a gentle simmer, cooking until the onions soften slightly.|5. Gently lower the fried whole fish directly into the bubbling coconut cream.|6. Spoon the hot cream and onions continuously over the fish, simmering for 5 minutes so the flavors fuse.|7. Finish with a splash of fresh lemon juice right before serving hot.
3343	710	1	Layer 4 to 5 fresh taro leaves flat in the palm of your hand to form a sturdy cup shape.|2. Place a small spoonful of minced onions, garlic, and optional corned beef into the center of the leaf cup.|3. Carefully pour a generous splash of thick, seasoned coconut cream directly over the onions.|4. Fold the edges of the taro leaves inward one by one to seal the liquid cream completely inside a neat ball.|5. Wrap the taro leaf ball securely in a piece of softened banana leaf or aluminum foil to make it waterproof.|6. Place the parcels into a steamer basket or directly into a lovo earth oven.|7. Steam on high heat for 1 hour until the taro leaves turn dark green and develop a buttery, incredibly soft texture.
3344	711	1	Mix the grated cassava, brown sugar, desiccated coconut, and spices together in a large bowl to form a thick, dark dough.|2. Soften banana leaves over a flame and cut them into uniform squares.|3. Place a log of the cassava mixture onto each leaf and roll it up tightly, tying the ends securely with string.|4. Steam the parcels in a boiling pot for 45 to 60 minutes until the cassava turns translucent and chewy.|5. While steaming, boil the thick coconut cream and brown sugar together in a pan until a rich, sticky caramel syrup forms.|6. Unwrap the hot cassava puddings and place them onto a serving dish.|7. Pour the hot coconut-caramel syrup heavily over the puddings before slicing.
3345	712	1	Melt the sugar in a heavy saucepan over medium-high heat, stirring continuously until it turns a deep, dark amber caramel.|2. Carefully pour the boiling water into the caramel, whisking rapidly until completely smooth.|3. Remove from heat and stir in the thick coconut milk and melted butter; let the liquid cool to lukewarm.|4. Sift the flour and baking powder together in a large bowl, adding the optional raisins.|5. Pour the cooled caramelized coconut liquid into the dry flour, mixing gently until a smooth, thick batter forms.|6. Pour the batter into a heavily greased pudding tin or mold with a tight lid.|7. Place the mold into a large pot of boiling water and steam for 1 hour until a skewer inserted comes out clean; serve warm.
3407	774	1	Brew a cup of strong coffee and let it cool down entirely in the refrigerator.|2. Place 2 large, generous scoops of creamy vanilla ice cream into the bottom of a tall glass.|3. Pour the ice-cold brewed coffee slowly over the vanilla ice cream scoops.|4. Spoon a massive, thick layer of whipped cream directly onto the top of the coffee.|5. Dust the surface of the whipped cream lightly with a sprinkle of cocoa powder or chocolate shavings.|6. Serve cold accompanied by a long straw and a tall spoon.
3346	713	1	Dissolve the yeast and sugar in warm water, letting it sit for 5 minutes until frothy.|2. Mix the yeast liquid into the flour and salt, kneading gently to form a soft, elastic dough.|3. Cover the bowl and let the dough rise in a warm spot for 1 hour until it doubles in size.|4. Roll the dough out thin onto a floured surface, cutting it into neat diamond or rectangular shapes.|5. Heat a generous amount of vegetable oil in a deep frying pan over medium-high heat.|6. Drop the dough cutouts into the hot oil; they will puff up instantly into hollow, golden pillows.|7. Fry for 1 to 2 minutes on each side until crisp, drain on paper towels, and serve immediately with honey or sugar.
3347	714	1	Mix the flour, sugar, yeast, warm water, and melted butter together, kneading into a smooth, elastic dough ball.|2. Let the dough rise for 1 hour until doubled, then divide and shape it into small, round tennis-sized balls.|3. Arrange the dough balls side-by-side inside a deep baking dish, leaving a little room for expansion.|4. Let the buns rise a second time for 20 minutes until they are puffed and touching.|5. Pour the sweetened coconut milk directly into the baking dish, filling it until the buns are sitting in a deep pool.|6. Bake at 180°C for 25 to 30 minutes.|7. The buns will absorb the sweet coconut milk from the bottom up, creating a sticky, custard-like base and a golden, fluffy top.
3348	715	1	Mash the very ripe bananas thoroughly in a bowl using a fork.|2. Stir in the sugar, flour, and baking powder until a thick paste forms.|3. Add a small splash of milk or water, mixing until the batter is smooth but still holds its shape on a spoon.|4. Heat cooking oil in a wide frying pan over medium heat.|5. Drop spoonfuls of the banana batter carefully into the hot oil.|6. Fry for 2 to 3 minutes on each side, turning carefully until they turn a deep golden-brown color.|7. Drain on paper towels and serve warm as a tea-time snack.
3349	716	1	Boil the cassava chunks in a pot of water until they are soft and easily pierced with a fork.|2. Drain the water and cut the hot cassava into small, bite-sized pieces, removing the fibrous woody core.|3. In a separate small saucepan, simmer the brown sugar and thick coconut cream together until it boils into a thick caramel.|4. Toss the warm cassava pieces directly into the hot coconut-sugar caramel sauce, coating them thoroughly.|5. Scatter a generous handful of freshly grated coconut flesh over the top.|6. Stir gently to combine all the textures together.|7. Serve warm in small bowls.
3350	717	1	Mix the shredded coconut, sweetened condensed milk, and vanilla extract together thoroughly in a large bowl.|2. In a separate clean bowl, whip the egg whites with a pinch of salt until stiff peaks form.|3. Gently fold the whipped egg whites into the sticky coconut mixture using a rubber spatula.|4. Drop rounded tablespoons of the mixture onto a baking sheet lined with parchment paper, shaping them into small pyramids.|5. Bake at 160°C for 15 to 20 minutes.|6. Watch the oven closely, removing the macaroons when the coconut tips turn a beautiful golden brown.|7. Let cool completely on a wire rack until firm.
3351	718	1	Mix the mashed bananas, sugar, and flour together in a bowl until a firm, sticky dough forms.|2. Bring a pot of coconut milk mixed with a little water to a gentle boil over medium heat.|3. Shape the banana dough into small, flat round discs or balls using wet hands.|4. Drop the dough balls carefully one by one into the boiling coconut milk.|5. Simmer uncovered for 15 to 20 minutes; the dumplings will float to the surface when they are cooked through.|6. The starch from the dumplings will naturally thicken the boiling coconut milk into a rich sauce.|7. Serve the dumplings hot, generously ladling the sweet coconut reduction over them.
3352	719	1	Line a pie dish with the shortcrust pastry, prick the base with a fork, and bake blind until lightly golden; let cool.|2. Heat the milk and sugar in a pot until warm.|3. Whisk the eggs, custard powder, vanilla essence, and optional yellow food coloring together in a separate bowl.|4. Slowly pour the warm milk into the egg mixture, whisking constantly to prevent curdling.|5. Pour the smooth liquid custard directly into the baked pie crust.|6. Bake at 160°C for 30 to 35 minutes until the custard layer is set but still retains a slight wobble in the center.|7. Cool completely, then refrigerate for 2 hours before slicing into neat wedges.
3353	720	1	Place 3 to 4 tablespoons of the fine, dried kava root powder directly inside a clean cloth straining bag.|2. Place the loaded bag into a large, traditional wooden bowl (tanoa) filled with cold water.|3. Knead and squeeze the bag continuously beneath the water using your hands for 10 to 15 minutes.|4. Watch the water turn an opaque, earthy brown color as the kava extracts mix into the liquid.|5. Wring the bag out firmly one last time to release all the concentrated juices, then discard the pulp.|6. Stir the earthy beverage thoroughly before serving.|7. Pour into a halved coconut shell bowl (bilo) and consume in a single, continuous gulp, clapping your hands once before and three times after drinking.
3354	721	1	Pick fresh, vibrant green leaves from a local citrus tree and wash them thoroughly under cold water.|2. Tear or bruise the leaves slightly with your fingers to break the surface cells and release the aromatic oils.|3. Drop the bruised leaves directly into a pot of boiling water.|4. Lower the heat and let the leaves simmer gently for 5 to 7 minutes until the water takes on a pale golden tint.|5. Turn off the heat and strain the herbal infusion into mugs, discarding the spent leaves.|6. Stir in a spoonful of sugar or wild honey to balance the natural herbal notes.|7. Serve piping hot.
3355	722	1	Carefully chop off the top of a fresh, young green coconut using a sharp knife to expose the inner liquid.|2. Pour the clear, refreshing coconut water through a sieve into a large glass pitcher.|3. Use a sharp spoon or a coconut scraper to gently scrape out the soft, translucent jelly-like flesh from the inner walls of the shell.|4. Drop the scraped coconut flesh directly into the pitcher of coconut water.|5. Add a handful of ice cubes to chill the mixture thoroughly.|6. Stir gently so the soft flesh floats evenly throughout the liquid.|7. Pour into tall glasses and serve ice-cold with a straw.
3356	723	1	Take a clean, chilled beer glass or pint glass.|2. Tilt the glass slightly and pour the crisp lager beer down the side until the glass is exactly half full.|3. Slowly top up the remaining half of the glass with the sparkling lemonade soda, allowing a clean, small head of foam to form on top.|4. Stir incredibly gently just once to integrate the sweet soda with the crisp bitterness of the beer.|5. Garnish the rim of the glass with a fresh lime wheel.|6. Serve immediately while ice-cold.
3357	724	1	Boil the bruised lemongrass stalks in a small pot of water for 10 minutes to create an intensely fragrant herbal base; let it cool completely.|2. Strain the cold lemongrass water into a large serving pitcher, discarding the stalks.|3. Pour equal parts fresh, sweet pineapple juice directly into the lemongrass water.|4. Taste the mixture, adding a small splash of sugar syrup if your pineapple juice is exceptionally tart.|5. Pack the pitcher tightly with plenty of ice cubes.|6. Stir vigorously with a long spoon to chill the punch thoroughly.|7. Garnish with fresh mint leaves and serve ice-cold in tall glasses.
3358	725	1	Fry the diced lardons in a large, heavy Dutch oven until crispy, then remove them with a slotted spoon, keeping the rendered fat in the pot.|2. Sear the chicken pieces in the hot bacon fat until the skin is deeply browned on all sides, then remove.|3. Sauté the pearl onions, mushrooms, and minced garlic in the same pot until soft and golden brown.|4. Stir in the tomato paste, then pour in the red wine and chicken stock, scraping up all the savory browned bits from the bottom.|5. Return the chicken and crispy lardons to the pot, cover tightly, and simmer on low heat for 45 to 50 minutes until the chicken is tender.|6. Remove the chicken briefly and whisk in a smooth paste of equal parts butter and flour (beurre manié) to thicken the wine sauce into a glossy gravy.|7. Place the chicken back into the rich sauce and serve hot alongside crusty bread or mashed potatoes.
3359	726	1	Brown the diced bacon in a large heavy pot until crisp, then remove and set aside.|2. Toss the beef cubes lightly in flour, then sear them in the hot bacon fat over high heat until a dark crust forms on all sides.|3. Remove the beef, throw in the sliced carrots and chopped onions, and sauté until they begin to soften.|4. Pour the red wine and beef stock into the pot, adding garlic, fresh thyme, and bay leaves.|5. Return the seared beef and bacon to the liquid, bring to a gentle simmer, cover tightly, and braise on low heat for 2.5 to 3 hours until the beef melts in your mouth.|6. In the final 20 minutes of cooking, pan-fry the pearl onions and mushrooms in butter until golden brown, then stir them directly into the stew.|7. Discard the bay leaves, adjust the seasoning with salt and pepper, and serve hot.
3360	727	1	Sauté the diced onions and garlic in olive oil inside a skillet, add the crushed tomatoes and tomato paste, and simmer into a thick, seasoned base sauce.|2. Spread the warm tomato-garlic sauce evenly across the bottom of a round baking dish.|3. Arrange the thin rounds of eggplant, zucchini, squash, and tomatoes over the sauce, alternating them tightly in a beautiful concentric circle pattern.|4. Drizzle a generous amount of high-quality olive oil over the top of the vegetable slices.|5. Sprinkle herbes de Provence, salt, and black pepper evenly across the vegetables.|6. Cover the baking dish with a piece of parchment paper cut to fit tightly inside the rim (this traps the steam while letting the top roast).|7. Bake at 190°C for 45 to 50 minutes until the vegetables are perfectly tender but still hold their shape beautifully.
3361	728	1	Rub the duck legs thoroughly with sea salt, crushed peppercorns, thyme, and bay leaves; cover and cure in the fridge for 24 hours.|2. Rinse the salt and spices completely off the duck legs under cold water and pat the skin totally dry with paper towels.|3. Melt the rendered duck fat in a deep, heavy ovenproof pot until it is completely liquid.|4. Submerge the cured duck legs into the warm fat, adding a few whole garlic cloves and thyme sprigs.|5. Cover tightly and cook in a low-temperature oven at 110°C for 3 to 4 hours until the meat is incredibly tender and easily pulls away from the bone.|6. Remove the duck legs carefully from the liquid fat and place them skin-side down into a hot skillet.|7. Sear for 4 to 5 minutes over medium-high heat until the skin turns ultra-crispy and deep golden brown; serve hot with roasted potatoes.
3362	729	1	Pat the fish fillets completely dry using paper towels, then season both sides with salt and white pepper.|2. Dredge the fish lightly through the flour, shaking off any excess so only a paper-thin coating remains.|3. Melt a generous knob of butter in a wide skillet over medium-high heat until it begins to foam and sizzle.|4. Place the floured fish carefully into the hot pan, cooking for 3 to 4 minutes until the bottom turns a delicate golden brown.|5. Carefully flip the fish over using a wide spatula and cook the other side for another 2 to 3 minutes, then transfer to a warm serving plate.|6. Wipe the pan quickly, add extra butter, and cook over medium heat until it turns a nutty, golden-brown color (beurre noisette).|7. Squeeze fresh lemon juice directly into the hot browned butter, stir in the chopped parsley, and pour the sizzling sauce instantly over the fish.
3363	730	1	Line a tart tin with the shortcrust pastry, prick the bottom with a fork, and bake blind with pie weights at 190°C for 15 minutes; let cool.|2. Fry the chopped bacon in a skillet until crispy, then drain on paper towels to remove excess grease.|3. Whisk the eggs, heavy cream, a pinch of ground nutmeg, salt, and pepper together in a bowl until perfectly smooth and airy.|4. Scatter the crispy bacon pieces evenly across the bottom of the pre-baked pastry shell.|5. Sprinkle the grated Gruyère cheese generously over the bacon layer.|6. Pour the egg and cream custard carefully into the tart shell, filling it right up to the brim.|7. Bake at 180°C for 30 to 35 minutes until the custard sets completely with a light, golden wobble in the center.
3364	731	1	Sauté the chopped fennel, onions, leeks, and garlic in a large pot with olive oil until soft and translucent.|2. Stir in the crushed tomatoes, tomato paste, saffron threads, and a strip of fresh orange peel.|3. Pour in the fish stock and bring the liquid to a rolling boil, letting the aromatic flavors fuse for 15 minutes.|4. Lower the heat slightly and add the firmest fish chunks first, letting them simmer for 5 minutes.|5. Toss in the mussels, clams, and prawns, covering the pot tightly with a lid.|6. Cook for another 5 minutes until the shellfish pop wide open and the prawns turn bright pink.|7. Discard the orange peel and serve the rich soup piping hot with croutons slathered in garlic-chili mayonnaise (rouille).
3365	732	1	Boil the soaked white beans in water with carrots, onions, and garlic until tender, then drain and reserve the cooking liquid.|2. Brown the pork sausages and pork belly chunks in a heavy skillet until crispy; remove and cut into bite-sized pieces.|3. In a deep earthenware dish (a cassole), layer one-third of the cooked white beans at the bottom.|4. Arrange the browned sausages, pork belly, and duck confit pieces evenly over the bean layer.|5. Cover the meats entirely with the remaining white beans, then pour in enough stock and bean liquid to barely submerge everything.|6. Sprinkle a dense layer of fresh breadcrumbs completely across the top surface.|7. Bake uncovered at 150°C for 2.5 to 3 hours, breaking the crust that forms on top with a spoon every 30 minutes to let the juices bubble through.
3366	733	1	To make the béchamel, melt butter in a pan, whisk in flour, and gradually pour in milk, whisking constantly until thick; season with nutmeg and salt.|2. Lightly toast the bread slices and spread a thin smear of Dijon mustard on the inside of each slice.|3. Lay slices of ham and a generous handful of grated Gruyère cheese on one slice of bread, capping it with the second slice.|4. Spread a little softened butter on the outside of the sandwich and toast in a hot pan until golden brown on both sides.|5. Place the toasted sandwich onto a baking sheet.|6. Ladle a thick, smooth blanket of the warm béchamel sauce over the entire top of the sandwich.|7. Sprinkle extra grated Gruyère cheese over the béchamel and grill under the oven broiler for 5 minutes until bubbling and brown.
3367	734	1	Soak the thin potato cuts in cold water to remove starch, dry thoroughly, and blanch in medium-hot oil (160°C) for 5 minutes until soft but not brown; drain.|2. Bring the steak to room temperature and season both sides heavily with coarse salt and cracked black pepper.|3. Heat a heavy cast-iron skillet over high heat until smoking hot, adding a touch of high-smoke-point oil.|4. Sear the steak for 2 to 3 minutes on each side, basting with a large dollop of butter and herbs in the final minute; remove to rest for 5 minutes.|5. Flash-fry the blanched potatoes a second time in very hot oil (190°C) for 2 minutes until ultra-crispy and golden brown; toss with sea salt.|6. Deglaze the steak pan quickly with chopped shallots and butter to create a simple pan juice reduction.|7. Slice the rested steak and serve immediately alongside the mountain of hot, crispy fries.
3368	735	1	Heat the heavy cream with the scraped vanilla bean seeds in a pot until it just starts to simmer, then remove from heat to infuse.|2. Whisk the egg yolks and caster sugar together in a bowl until pale and slightly thickened.|3. Slowly pour the warm cream into the egg mixture in a thin stream, whisking constantly to avoid cooking the eggs.|4. Strain the smooth custard liquid through a fine sieve into individual shallow ramekins.|5. Place the ramekins inside a deep baking tray filled halfway with hot water (a bain-marie water bath).|6. Bake at 150°C for 30 to 35 minutes until the edges are set but the center still has a slight wobble; chill in the fridge for 3 hours.|7. Sprinkle a thin, even layer of sugar across the cold custard and torch it with a kitchen blowtorch until it melts into a hard, amber caramel shell.
3369	736	1	Melt the butter and sugar together directly in a heavy, ovenproof skillet over medium heat, stirring until it turns a rich caramel color.|2. Arrange the apple quarters tightly and neatly in a circular pattern inside the bubbling caramel pan.|3. Cook the apples in the caramel for 15 minutes over low heat until they soften slightly and absorb the golden syrup.|4. Remove the skillet from the heat and let it cool for a few minutes.|5. Lay the circular puff pastry sheet carefully directly over the hot caramelized apples.|6. Tuck the overhanging edges of the pastry dough firmly down inside the sides of the pan to envelope the apples.|7. Bake at 200°C for 25 to 30 minutes until the pastry is puffed and golden brown, then let cool for 5 minutes before carefully flipping upside down onto a platter.
3370	737	1	Sift the fine almond flour and icing sugar together twice to remove any large lumps; set aside.|2. Whip the egg whites until foamy, then gradually add the caster sugar, beating at high speed until a stiff, glossy meringue forms.|3. Fold the dry almond mixture into the meringue gently using a rubber spatula (the macaronage process) until the batter falls like molten lava.|4. Pipe the smooth batter into neat, small circles onto a baking sheet lined with a silicone mat.|5. Tap the tray firmly on the counter to release trapped air bubbles, then let the shells sit untouched for 45 minutes until a dry skin forms on top.|6. Bake at 150°C for 12 to 14 minutes until they rise to form characteristic crinkly "feet" at the bottom; let cool completely.|7. Match the cooled shells into pairs and sandwich them together with a dollop of rich chocolate ganache or buttercream.
3371	738	1	Boil water and butter, stir in flour quickly to form a dough ball, then beat in eggs one by one until a smooth, glossy paste forms.|2. Pipe mounds of the choux paste onto a baking sheet and bake at 200°C for 20 to 25 minutes until puffed, hollow, and crisp; let cool.|3. Slice each cooled pastry puff horizontally in half using a serrated knife to create a lid.|4. Melt the dark chocolate chunks with heavy cream in a small bowl over simmering water to create a smooth, warm sauce.|5. Place a generous scoop of vanilla ice cream directly inside the bottom half of each pastry shell.|6. Cap the ice cream with the top pastry lid.|7. Arrange the stuffed puffs on a plate and drizzle the warm dark chocolate sauce heavily over the top right before serving.
3372	739	1	Pipe the prepared choux pastry dough into long 10cm oblong log shapes onto a baking sheet.|2. Bake at 200°C for 25 minutes until the shells are golden brown, dry, and hollow; let cool completely.|3. Make three small holes in the bottom of each cooled pastry shell using a piping tip.|4. Fill a piping bag with the chilled, silky vanilla pastry cream.|5. Insert the piping tip into the holes and pipe the pastry cream inside until the éclair feels heavy and filled.|6. Melt the dark chocolate with a knob of butter to create a smooth, glossy decorating glaze.|7. Dip the top surface of the stuffed éclair directly into the chocolate glaze, smoothing it with your finger, and let it set.
3373	740	1	Whisk the eggs and sugar together vigorously using an electric mixer until thick, pale, and ribbon-like.|2. Gently fold in the sifted flour and baking powder, followed by the fresh lemon zest.|3. Pour the cooled melted butter slowly down the side of the bowl, folding it in gently until a uniform batter forms.|4. Cover the batter and refrigerate it for at least 1 hour (the temperature contrast is what creates the iconic hump).|5. Spoon the cold batter into a greased and floured shell-shaped madeleine tray.|6. Bake in a hot oven at 190°C for 8 to 10 minutes.|7. Watch for the center to puff up into a prominent hump and the edges to turn golden; unmold immediately and dust with powdered sugar.
3374	741	1	Brush the insides of ramekins with softened butter using upward strokes, then coat the interior completely with sugar; chill.|2. Make a thick paste with butter, flour, and milk, then stir in the melted dark chocolate and egg yolks until smooth.|3. Whip the egg whites with sugar in a clean bowl until stiff, glossy peaks form.|4. Fold one-third of the whipped egg whites into the chocolate base vigorously to lighten the texture.|5. Gently fold in the remaining egg whites using a rubber spatula, taking care not to deflate the trapped air.|6. Pour the batter into the prepared ramekins, filling them flat to the top edge, and scrape the rim cleanly with your thumb.|7. Bake at 190°C for 12 to 15 minutes without opening the oven door; serve immediately before the high puff falls.
3375	742	1	Bake the puff pastry sheets flat between two baking trays weighted down so they crisp up without rising too high.|2. Cut the baked, crispy pastry sheets into uniform rectangular strips using a sharp serrated knife.|3. Lay one strip of pastry down and pipe a dense, uniform layer of vanilla pastry cream across it.|4. Place a second pastry strip over the cream, pressing down gently, and pipe a second layer of pastry cream.|5. Cap the dessert with the third crispy pastry layer.|6. Spread a thin layer of white icing sugar glaze smoothly over the top pastry layer.|7. Pipe parallel lines of melted chocolate across the glaze, then drag a toothpick perpendicularly through them to create the iconic feathered pattern; chill before serving.
3428	795	1	Pack exactly 7 to 9 grams of finely ground coffee into the portafilter basket of an espresso machine.|2. Use a metal tamper to press the coffee grounds down flat with firm, level pressure to ensure uniform extraction.|3. Lock the portafilter tightly into the group head of the heated espresso machine.|4. Engage the pump, forcing hot water through the compacted coffee puck at 9 bars of pressure.|5. Extract the liquid for 25 to 30 seconds into a warm ceramic demitasse cup.|6. Stop the extraction precisely when the volume reaches 25 to 30 milliliters.|7. Serve immediately, showcasing a thick, hazelnut-colored cream layer (crema) floating perfectly on top.
3376	743	1	Whisk the crêpe ingredients into a very thin batter and let it rest in the refrigerator for 30 minutes.|2. Cook the batter a small ladleful at a time in a hot, buttered non-stick skillet to create twenty paper-thin, golden crêpes; let cool completely.|3. Fold whipped heavy cream into the vanilla pastry cream to create a light, spreadable crème diplomate filling.|4. Place one cold crêpe flat onto a serving plate.|5. Spread a very thin, even layer of the cream mixture smoothly across the crêpe, extending close to the edges.|6. Top with the second crêpe and repeat the layering process until all twenty crêpes are stacked neatly on top of each other.|7. Refrigerate the finished cake for at least 4 hours to set the layers firmly together before slicing into wedges.
3377	744	1	Pipe the choux pastry dough into a large, thick circular ring shape onto a baking sheet lined with parchment paper.|2. Sprinkle the sliced blanched almonds generously over the top of the wet dough ring.|3. Bake at 190°C for 30 minutes until the ring puffs up dramatically, turns golden brown, and feels completely dry.|4. Let the pastry wheel cool completely, then slice it horizontally in half to create a top and bottom ring.|5. Whip the pastry cream, butter, and nutty praline paste together until it forms a thick, fluffy, and decadent mousseline cream.|6. Pipe the rich praline cream in large, decorative swirls all along the inside of the bottom pastry ring.|7. Place the almond-crusted top pastry ring carefully over the cream and dust the entire wheel heavily with powdered sugar.
3378	745	1	Add the coarsely ground coffee beans into the bottom of a clean French press glass carafe.|2. Pour hot water steadily over the coffee grounds, ensuring all the coffee is fully saturated.|3. Stir the mixture gently with a spoon once, allowing a light crema foam to form on the surface.|4. Place the plunger lid on top of the carafe with the mesh filter pulled all the way up.|5. Let the coffee steep undisturbed for exactly 4 minutes to extract the full oils and flavor profiles.|6. Press the plunger down slowly and steadily with even pressure to push the coffee grounds flat to the bottom.|7. Pour the rich coffee immediately into cups to stop the brewing process.
3379	746	1	Pour the whole milk and heavy cream into a small saucepan over medium heat, bringing it to a gentle simmer.|2. Turn the heat down to low and add the finely chopped dark chocolate pieces into the warm milk.|3. Whisk the mixture continuously as the chocolate melts completely into the liquid.|4. Simmer gently on low heat for 3 to 5 minutes, stirring constantly until the drink thickens into a rich, velvety consistency.|5. Taste and stir in a tiny pinch of sugar if your dark chocolate is exceptionally bitter.|6. Pour the thick, decadent liquid into small espresso cups or mugs.|7. Serve hot, accompanied by a dollop of whipped cream if desired.
3380	747	1	Take a clean, chilled Champagne flute glass.|2. Pour a splash (about 1 to 2 teaspoons) of Crème de Cassis directly into the bottom of the flute.|3. Tilt the glass slightly to avoid excessive foaming.|4. Top up the glass slowly with the ice-cold sparkling Champagne.|5. Watch the brilliant red blackcurrant liqueur blend naturally with the golden bubbles, turning the drink a beautiful ruby-pink color.|6. Serve immediately without stirring to maintain the carbonation.
3381	748	1	Peel the bright yellow skins off the lemons using a peeler, taking care to avoid the bitter white pith.|2. Simmer the lemon peels, sugar, and water together in a saucepan for 10 minutes to create an intensely aromatic simple syrup; let cool.|3. Squeeze the peeled lemons to extract fresh, clean juice, straining out any stray seeds.|4. Pour the fresh lemon juice and the cooled lemon-peel syrup into a large pitcher.|5. Dilute the mixture with cold water, stirring well to combine the sweet and sour notes.|6. Pack the pitcher with ice cubes and a few fresh mint leaves.|7. Serve ice-cold in tall glasses.
3382	749	1	Brew a fresh pot of exceptionally strong dark roast coffee using a drip filter or a stovetop moka pot.|2. Heat the fresh whole milk in a small saucepan over medium heat until it is hot and steaming (do not let it boil over).|3. Take a traditional wide ceramic breakfast bowl or large mug.|4. Hold the hot coffee pot in one hand and the hot milk pan in the other hand.|5. Pour the hot coffee and the steaming milk into the bowl simultaneously in equal proportions.|6. The two liquids will mix together perfectly mid-air, creating a smooth, light-brown beverage with a very thin layer of natural foam on top.|7. Serve hot, traditionally enjoyed alongside a flaky croissant for dipping.
3383	750	1	Boil the vinegar, red wine, chopped vegetables, and spices together, then let the liquid cool completely.|2. Place the beef roast into a deep glass bowl, pour the cooled marinade over it, cover tightly, and refrigerate for 3 to 5 days, turning the meat daily.|3. Remove the beef from the liquid, pat it completely dry with paper towels, and season with salt.|4. Sear the beef in a hot Dutch oven with oil until a deep brown crust forms on all sides.|5. Strain the marinade, adding the liquid and the vegetables back into the pot with the beef.|6. Cover tightly and slow-braise over low heat for 2.5 to 3 hours until the meat is incredibly tender.|7. Remove the meat, stir the crushed gingerbread cookies into the bubbling pan juices to dissolve, creating a thick, glossy, sweet-and-sour gravy to pour over the sliced roast.
3384	751	1	Place the meat cutlets between sheets of plastic wrap and pound them firmly with a meat mallet until evenly thin (about 4mm).|2. Season both sides of the flattened cutlets generously with salt and black pepper.|3. Set up three shallow bowls: one with flour, one with beaten eggs, and one with plain breadcrumbs.|4. Dredge a cutlet in the flour, dip it into the beaten eggs, and coat it gently with breadcrumbs (do not press the breadcrumbs into the meat; a loose coat allows the crust to soufflé).|5. Melt a large amount of lard or clarified butter in a wide skillet over medium-high heat (the fat should be deep enough for the schnitzel to swim).|6. Slide the crumbed cutlet into the hot fat, gently shaking the pan continuously so the hot oil washes over the top surface.|7. Fry for 2 to 3 minutes on each side until wavy, puffy, and golden brown; drain on paper towels and serve with a fresh lemon squeeze.
3385	752	1	Lay the thin beef slices flat on a cutting board and season lightly with salt and pepper.|2. Spread a generous tablespoon of spicy German mustard completely across the top of each beef slice.|3. Lay a strip of bacon down the center of the meat, followed by a handful of sliced onions and a dill pickle spear.|4. Fold the long edges of the beef slightly inward, then roll the steak up tightly from the bottom to trap the filling completely.|5. Secure the beef rolls tightly using kitchen twine or metal rouladen needles.|6. Sear the beef rolls in a hot pan with butter until browned beautifully on all sides, then pour in the beef stock and red wine.|7. Cover tightly and simmer on low heat for 1.5 to 2 hours until tender; remove the rolls, whisk flour into the pan liquids to create a rich gravy, and serve.
3386	753	1	Whisk flour, eggs, salt, a pinch of nutmeg, and sparkling water together vigorously until a thick, elastic noodle batter forms and bubbles appear.|2. Sauté the sliced onion rings in a generous amount of butter over medium-low heat until dark golden brown, sweet, and caramelized; set aside.|3. Bring a large pot of salted water to a rolling boil.|4. Scrape the sticky batter through a Spätzle press or slide small strips off a wooden board directly into the boiling water.|5. Cook the noodles for just 1 to 2 minutes until they float to the surface, then lift them out cleanly using a slotted spoon.|6. In a warm baking dish, layer the hot noodles immediately with handfuls of the grated cheese, repeating until the dish is piled high.|7. Top the cheesy noodles with the warm caramelized onions and bake at 180°C for 10 minutes until the cheese is completely molten and stringy.
3387	754	1	Mix the minced meat, soaked bread roll, egg, chopped onions, and mashed anchovies together thoroughly in a bowl.|2. Roll the seasoned meat mixture into smooth, medium-sized uniform balls.|3. Bring the beef stock to a gentle simmer in a wide pot and lower the meatballs carefully into the liquid.|4. Poach the meatballs gently for 15 minutes over low heat (do not let the water boil rapidly, or the meatballs will break); remove and keep warm.|5. Melt butter in a separate saucepan, whisk in flour to make a pale roux, and gradually pour in the poaching stock, whisking until smooth.|6. Stir the heavy cream and a generous handful of capers into the sauce, simmering until it turns thick and velvety.|7. Return the poached meatballs to the cream sauce, heat through for 2 minutes, and serve warm with boiled potatoes.
3388	755	1	To make the sauce, simmer tomato paste, ketchup, vinegar, Worcestershire sauce, sugar, onion powder, and a tablespoon of curry powder in a saucepan until smooth.|2. Heat a flat griddle pan or skillet with vegetable oil over medium heat.|3. Fry the pork sausages turning regularly until the casing is perfectly browned and crispy all around.|4. Remove the hot sausages from the pan and cut them into bite-sized coin rounds using a sharp knife or scissors.|5. Arrange the sausage slices neatly across a serving plate or paper tray.|6. Ladle a generous blanket of the warm, thick spiced tomato sauce directly over the sausage pieces.|7. Dust the top heavily with extra dry curry powder through a fine sieve right before serving alongside fries.
3389	756	1	Use a sharp knife to score the thick pork rind in a diamond pattern, taking care not to cut into the meat underneath.|2. Rub coarse salt, mashed garlic, and crushed caraway seeds heavily into the scored skin and into the meat sides.|3. Place the chopped onions and carrots into a roasting pan, lay the pork knuckle on top, and pour a little water into the base.|4. Roast in a preheated oven at 160°C for 2.5 hours, basting the meat occasionally with German lager beer.|5. Once the meat is entirely tender, crank the oven temperature up to 230°C for the final 20 minutes.|6. Watch closely as the high heat causes the pork rind to blister, puff up, and turn into a loud, crunchy crackling shell.|7. Remove from the oven, let rest for 10 minutes, and serve hot with potato dumplings and gravy.
3390	757	1	Rinse the cured pork knuckle briefly under cold running water to remove any excessive surface salt.|2. Place the large pork knuckle inside a deep, heavy boiling pot.|3. Add the quartered onions, whole garlic cloves, bay leaves, juniper berries, and peppercorns around the meat.|4. Pour in enough cold water to cover the pork knuckle completely.|5. Bring the pot to a rolling boil, then skim off any foam that rises to the surface using a spoon.|6. Reduce the heat to low, cover tightly with a lid, and let it simmer gently for 2 to 2.5 hours until the meat is fork-tender and pulls away from the bone.|7. Lift the tender meat out of the aromatic broth and serve hot alongside sauerkraut and pea puree.
3391	758	1	Sauté the chopped onions and parsley in a pan until soft, then mix with the minced meat, chopped spinach, soaked bread, egg, salt, and pepper.|2. Lay a long sheet of fresh pasta dough flat onto a floured workspace.|3. Spread the meat and spinach filling evenly across the bottom half of the pasta sheet.|4. Fold the top half of the pasta dough over the filling, pressing down firmly between sections to remove trapped air.|5. Cut the dough into large, rectangular pocket squares using a pastry wheel or knife, sealing the edges tightly with a fork.|6. Bring a deep pot of rich beef broth to a gentle simmer over medium-low heat.|7. Drop the pasta pockets into the simmering broth and cook for 10 to 12 minutes until they float; serve hot directly in bowls of the clear broth.
3392	759	1	Process the chilled meat, bacon fat, spices, and crushed ice in a high-powered food processor until it forms a perfectly smooth, pink paste.|2. Grease a rectangular bread loaf tin thoroughly with butter or oil.|3. Pack the smooth meat paste tightly into the loaf tin, pressing down firmly to eliminate any hidden air pockets.|4. Score the top surface of the meat paste in a crosshatch diamond pattern using a wet knife.|5. Bake in a preheated oven at 160°C for 1 hour.|6. The meatloaf will rise slightly and expand, developing a deep, rich reddish-brown outer crust.|7. Slice thick and serve hot inside a crusty bread roll (Semmel) with sweet German mustard.
3393	760	1	Toss the sliced apples, rum-soaked raisins, sugar, and ground cinnamon together in a large bowl.|2. Lay the stretched strudel dough flat onto a clean kitchen towel and brush it generously with melted butter.|3. Sprinkle the toasted buttery breadcrumbs evenly over two-thirds of the dough sheet.|4. Mound the spiced apple mixture in a neat log shape along the edge covered in breadcrumbs.|5. Roll the dough up tightly around the apples using the kitchen towel to lift and guide the roll cleanly.|6. Tuck the open ends of the dough roll underneath securely and place the strudel onto a lined baking sheet.|7. Brush the exterior heavily with melted butter and bake at 190°C for 35 to 40 minutes until golden brown and flaky; dust with powdered sugar.
3394	761	1	Bake a rich chocolate sponge cake and slice it horizontally into three even, flat layers once cooled.|2. Drizzle a generous amount of Kirschwasser brandy evenly across each chocolate sponge layer to soak the cake.|3. Whip the heavy cream with vanilla sugar until stiff, pipeable peaks form.|4. Place the bottom sponge layer on a plate, spread a thick blanket of whipped cream over it, and press sour cherries closely into the cream.|5. Top with the second sponge layer, repeating the cream and cherry filling process.|6. Place the final sponge layer on top and coat the entire exterior of the cake smoothly with the remaining whipped cream.|7. Decorate the borders with piped cream rosettes and whole cherries, then coat the center heavily with dark chocolate shavings.
3395	762	1	Bring the fruit juice and sugar to a boil in a saucepan, stirring until the sugar dissolves completely.|2. Whisk the cornstarch with a small splash of cold juice until smooth, then stir it into the boiling liquid.|3. Cook for 1 minute, stirring constantly as the liquid thickens into a glossy, clear syrup.|4. Gently fold all the fresh or frozen red berries into the hot thickened syrup.|5. Simmer on low heat for 3 to 4 minutes just until the fruits soften slightly but still hold their shape without breaking down completely.|6. Pour the berry pudding into small dessert bowls and let it cool, then refrigerate for 2 hours to set.|7. Serve cold, floating a generous pool of cool vanilla cream sauce around the red berry mound.
3396	763	1	Line the bottom of a springform cake tin with the shortcrust pastry dough and press it flat; chill.|2. Whisk the Quark cheese, egg yolks, sugar, vanilla pudding powder, lemon zest, and fresh lemon juice together until perfectly smooth.|3. Whip the egg whites in a clean glass bowl until stiff, glossy peaks form.|4. Fold the whipped egg whites very gently into the heavy Quark mixture using a rubber spatula to retain the trapped air.|5. Pour the fluffy cheese filling into the pastry-lined tin, smoothing out the surface.|6. Bake at 160°C for 1 hour until the top is pale golden and the cake has expanded uniformly.|7. Turn off the oven and let the cheesecake cool completely inside with the door propped open slightly to prevent it from cracking or collapsing.
3397	764	1	Place a large dollop of chilled whipped cream directly onto the center of a cold dessert plate.|2. Pack a chilled potato ricer with two large, firm scoops of vanilla ice cream.|3. Squeeze the potato ricer firmly over the plate, letting the ice cream fall in long, noodle-like strands completely covering the whipped cream base.|4. Spoon the red strawberry sauce carefully down the center of the ice cream noodles to resemble tomato marinara sauce.|5. Grate the white chocolate finely over the top of the dessert using a microplane to mimic grated parmesan cheese.|6. Serve instantly while the ice cream strands are perfectly formed.
3398	765	1	Roll out the risen yeast dough into a rectangle and place it into a lined baking tin.|2. Melt butter, honey, and sugar together in a pan, stir in the sliced almonds, and boil for 1 minute until sticky.|3. Spread the warm honey-almond mixture evenly across the top of the unbaked yeast dough layer.|4. Bake at 180°C for 25 minutes until the almond topping turns a deep caramel brown and hardens into a crunch; let cool.|5. Carefully cut the cooled cake horizontally in half to create a top crust layer and a bottom base layer.|6. Slice the top almond layer into individual portion squares before assembling (this prevents the cream from squishing out later when slicing).|7. Spread a thick layer of vanilla custard cream over the bottom cake base, place the pre-sliced almond squares on top, and chill.
3399	766	1	Shape your risen yeast dough into smooth, uniform round balls about the size of a billiard ball; let them rise for 20 minutes.|2. In a large, heavy skillet with a tight-fitting lid, combine the milk, butter, and a few tablespoons of sugar.|3. Heat the skillet until the butter melts and the liquid begins to simmer gently.|4. Arrange the yeast buns side-by-side in the pan, leaving a little space around each ball.|5. Cover the skillet tightly with the lid and cook over medium-low heat for exactly 25 minutes without lifting the lid.|6. The liquid will steam the tops of the buns while the sugar and butter caramelize at the bottom, creating a golden, crunchy sweet crust.|7. Listen for a cracking sound indicating the water has evaporated, remove from heat, and serve the fluffy buns hot drenched in vanilla sauce.
3400	767	1	Whisk flour, milk, sugar, and egg yolks into a smooth batter, then fold in the stiffly whipped egg whites gently.|2. Melt a generous knob of butter in a wide skillet over medium heat and pour the thick batter inside, scattering raisins over the top.|3. Cook for 4 to 5 minutes until the bottom is golden, then flip the large pancake over using a spatula.|4. Use two forks to tear the thick pancake into small, rustic bite-sized pieces directly inside the hot pan.|5. Add extra butter and a sprinkle of sugar over the torn pieces, tossing them continuously until the sugar melts and caramelizes the edges.|6. Slide the hot shredded pancake onto a plate and dust heavily with powdered sugar.|7. Serve warm alongside a dish of tart plum compote.
3401	768	1	Roll out the yeast dough and cut into neat circles, letting them rise on a tray for 30 minutes until puffy and light.|2. Heat a deep pan of oil to 170°C.|3. Drop the risen dough rounds carefully into the hot oil, covering the pan with a lid for the first 2 minutes.|4. Flip the donuts over and fry uncovered for another 2 minutes until both sides are deep golden brown with a pale white band running around the middle.|5. Remove with a slotted spoon and drain on paper towels.|6. Load a pastry bag fitted with a long injector tip with the red fruit jam.|7. Insert the tip into the side of the warm donut, squeeze a generous tablespoon of jam inside, and roll the entire donut in sugar.
3402	769	1	Whip the egg whites until stiff peaks form, then gradually whisk in the icing sugar until a thick, glossy meringue glaze is achieved.|2. Set aside a small bowl of the white meringue glaze to use later for the top icing.|3. Fold the ground almonds, ground cinnamon, and salt into the remaining meringue to form a stiff, sticky cookie dough.|4. Roll the dough out between sheets of baking paper to a thickness of about 1cm.|5. Cut the dough into star shapes using a cookie cutter, dipping the cutter in water frequently to prevent sticking.|6. Spread the reserved white meringue glaze smoothly across the top of each raw dough star using a small knife.|7. Bake at a very low temperature (130°C) for 12 to 15 minutes until the cookie bottoms are set but the white meringue icing stays bright white.
3403	770	1	Take a large glass or mug and fill it halfway with fresh ice cubes.|2. Pour the chilled orange soda into the glass until it reaches exactly the halfway mark.|3. Slowly top up the remaining half of the glass with the chilled cola soda.|4. Stir very gently once with a long spoon to mix the two sodas without losing the carbonation bubbles.|5. Garnish the rim of the glass with a slice of fresh orange.|6. Serve immediately while ice-cold.
3404	771	1	Select a tall, clean glass.|2. Pour the clear apple juice into the glass until it is about 50% to 60% full depending on your desired sweetness.|3. Top up the glass slowly with the ice-cold sparkling mineral water.|4. The natural fizz of the mineral water will mix with the apple juice instantly.|5. Do not stir heavily, as you want to preserve the refreshing, sharp bite of the carbonation bubbles.|6. Serve ice-cold without ice, as is traditional in Germany.
3405	772	1	Pour the whole bottle of dry red wine into a large, heavy saucepan over medium heat.|2. Add the orange slices, cinnamon sticks, whole cloves, and star anise directly into the wine.|3. Stir in the sugar until it dissolves completely.|4. Heat the wine slowly until it just begins to steam, but do not let it boil (boiling evaporates the alcohol and alters the flavor profile).|5. Turn the heat down to low, cover the pot, and let the spices infuse for 20 to 30 minutes.|6. Strain the hot wine through a fine sieve to remove the fruit and whole spices.|7. Ladle into ceramic mugs and serve hot during cold evenings.
3406	773	1	Take a clean, chilled beer glass or pint glass.|2. Tilt the glass at an angle and fill it halfway with the sparkling lemon-lime lemonade soda.|3. Slowly pour the pale lager beer down the inside of the glass over the lemonade.|4. Allow a clean, small white foam head to form naturally at the surface.|5. The combination creates a beautifully bright, straw-colored drink that balances sweet citrus with crisp, bitter hops.|6. Serve ice-cold immediately on hot summer afternoons.
3408	775	1	Sauté the finely diced onion, carrot, and celery in a mixture of olive oil and butter until soft and aromatic.|2. Add the minced beef and pork, browning the meat thoroughly while breaking up any large clumps.|3. Pour in the wine, simmering gently until the alcohol evaporates completely.|4. Add the tomato paste dissolved in a little beef stock, then lower the heat to a bare simmer.|5. Pour in the milk gradually over the cooking process, letting it simmer uncovered for 2 to 3 hours until thick and rich.|6. Boil the fresh tagliatelle pasta in a large pot of salted water until al dente.|7. Drain the pasta, toss it directly into the bubbling meat ragù, and finish with a handful of Parmigiano-Reggiano.
3409	776	1	Melt the bone marrow or a generous knob of butter in a wide pan and sauté the minced onions until translucent.|2. Add the raw rice to the pan, stirring constantly for 2 minutes to toast the grains until they appear translucent.|3. Pour in the dry white wine and stir continuously until the liquid is entirely absorbed by the rice.|4. Add a ladleful of the hot stock and the steeped saffron liquid, stirring constantly over medium-low heat.|5. Continue adding stock one ladle at a time only after the previous addition has been fully absorbed, stirring to release the starches.|6. Cook for 16 to 18 minutes until the rice grains are creamy on the outside but still firm to the bite.|7. Remove from the heat and vigorously beat in cold butter and grated Parmigiano-Reggiano (mantecatura) until incredibly glossy.
3410	777	1	Tie kitchen twine securely around the exterior of each veal shank to prevent the meat from falling apart during braising.|2. Dredge the shanks lightly through flour, shaking away any excess coating.|3. Sear the meat in a hot Dutch oven with oil and butter until a dark golden crust forms on both sides; remove.|4. Add the diced onions, carrots, and celery into the same pan, sautéing until soft.|5. Pour in the white wine, scraping up the browned bits from the pan base, and let it reduce by half.|6. Return the shanks to the pot, add the crushed tomatoes and enough stock to come halfway up the meat, and cover tightly.|7. Braise in the oven at 160°C for 2 hours until the meat is fork-tender, and sprinkle with fresh gremolata right before serving.
3411	778	1	Sauté whole garlic cloves in extra virgin olive oil, add the tomato passata and salt, and simmer for 15 minutes to create a thick sauce.|2. Discard the garlic cloves and stir several torn fresh basil leaves into the warm tomato sauce.|3. Drop the potato gnocchi into a large pot of boiling salted water.|4. Cook for just 1 to 2 minutes, lifting them out immediately with a slotted spoon as soon as they float to the surface.|5. Toss the hot gnocchi gently directly into the prepared tomato sauce.|6. Transfer the coated gnocchi into a clay baking dish, layering them with the fresh mozzarella cubes and grated Parmigiano.|7. Bake under a hot broiler at 220°C for 8 to 10 minutes until the cheese is completely molten, bubbly, and browned in spots.
3412	779	1	Season the chicken pieces heavily with salt and black pepper.|2. Heat olive oil in a deep skillet and sear the chicken pieces skin-side down until crispy and golden brown; remove.|3. Toss the sliced onions, bell peppers, and mashed garlic into the hot pan drippings, cooking until they soften.|4. Pour in the wine, simmering rapidly until the liquid reduces by half.|5. Crush the plum tomatoes by hand into the pan, returning the seared chicken along with the fresh rosemary and thyme.|6. Cover the skillet and simmer on low heat for 35 to 40 minutes until the chicken meat is tender and cooked through.|7. Stir in the black olives during the final 5 minutes of cooking, letting the sauce reduce uncovered until thick.
3413	780	1	Layer the eggplant slices in a colander, sprinkling each layer with coarse salt, and let them sit for 1 hour to drain bitter juices.|2. Rinse the salt off thoroughly and pat each eggplant slice completely dry using a clean kitchen towel.|3. Shallow-fry the eggplant slices in hot oil until golden brown on both sides; drain well on paper towels.|4. Spread a thin layer of the prepared tomato sauce across the bottom of a rectangular baking dish.|5. Arrange a single layer of fried eggplants over the sauce, followed by a sprinkle of mozzarella, Parmigiano, and fresh basil leaves.|6. Repeat the layering process until the dish is full, finishing with a dense layer of tomato sauce and grated cheese on top.|7. Bake at 180°C for 30 minutes until the edges bubble vigorously and the cheese forms a rich, uniform crust.
3414	781	1	Soak the fresh clams in cold salted water for 2 hours, changing the water frequently to ensure all sand is purged.|2. Cook the spaghetti in a large pot of boiling salted water until it is 2 minutes away from being al dente.|3. Heat a generous amount of extra virgin olive oil in a wide skillet, frying the sliced garlic and chili flakes until fragrant.|4. Toss the clean clams into the hot skillet and pour in the dry white wine immediately.|5. Cover the pan tightly with a lid and steam over high heat for 3 to 4 minutes until all the clam shells pop open wide.|6. Transfer the undercooked spaghetti directly into the clam pan along with a ladleful of the starchy pasta cooking water.|7. Toss vigorously over high heat to emulsify the oils and pasta water into a glossy sauce, finishing with fresh parsley.
3415	782	1	Place the veal cutlets flat on a board and pound them with a mallet until uniform and very thin.|2. Lay a slice of prosciutto smoothly over the top of each veal cutlet.|3. Place a fresh sage leaf directly onto the center of the prosciutto layer.|4. Weave a toothpick through the sage leaf, prosciutto, and meat to secure the layers firmly together.|5. Dredge only the bottom underside of the veal cutlets lightly through the flour.|6. Melt butter and olive oil in a skillet, searing the cutlets prosciutto-side down for 1 minute before flipping to cook the floured side for 2 minutes.|7. Remove the meat, pour white wine directly into the hot pan to deglaze, and whisk in a cold knob of butter to form a velvety sauce.
3416	783	1	Bring the massive steak to room temperature for at least 2 hours before cooking to ensure even heat penetration.|2. Prepare a very hot charcoal grill using hardwood coals until they are glowing white-hot.|3. Place the dry steak directly onto the hot grill grate without adding any oil or seasonings initially.|4. Grill undisturbed for 5 minutes on one side to develop a dark, charred crust, then flip carefully.|5. Generously sprinkle coarse sea salt and cracked black pepper onto the seared top surface.|6. Grill the second side for another 5 minutes, then stand the steak upright on its thick bone for 5 minutes to heat the core.|7. Remove from the heat, let it rest for 10 minutes, slice into thick ribbons, and drizzle with extra virgin olive oil.
3417	784	1	Lay the pork belly skin-side down on a workspace and score the meat flesh in a diamond pattern.|2. Scatter the minced garlic, chopped rosemary, sage, crushed fennel seeds, chili flakes, salt, and pepper heavily across the meat.|3. Roll the pork belly up tightly into a dense log shape, wrapping the crispy skin completely around the exterior.|4. Tie the pork roll exceptionally tightly at 2cm intervals using heavy kitchen twine to maintain its shape.|5. Poke small holes all over the skin using a sharp skewer and rub the exterior thoroughly with coarse salt.|6. Roast on a wire rack inside an oven at 150°C for 3.5 to 4 hours until the internal temperature is hot and the meat is tender.|7. Crank the oven heat to 230°C for the final 20 minutes to blister and puff the skin into a loud, crunchy crackling glass shell.
3418	785	1	Whisk the egg yolks and caster sugar together in a bowl until pale, thick, and ribbon-like.|2. Fold the mascarpone cheese gently into the egg yolk paste until smooth and free of large lumps.|3. Whip the egg whites in a clean glass bowl until stiff peaks form, then fold them gently into the mascarpone paste to create a light cream.|4. Dip the ladyfinger biscuits quickly into the cooled espresso coffee, ensuring they absorb flavor without turning soggy.|5. Arrange the soaked ladyfingers tightly side-by-side along the bottom of a rectangular glass serving dish.|6. Spread half of the fluffy mascarpone cream smoothly over the biscuit layer.|7. Repeat with a second layer of soaked ladyfingers and cream, chilling for 4 hours before dusting heavily with dark cocoa powder.
3419	786	1	Soak the gelatin leaves in a bowl of cold water for 5 minutes until soft and pliable.|2. Combine the heavy cream, whole milk, sugar, and the scraped vanilla bean seeds in a saucepan over medium heat.|3. Bring the liquid to a gentle simmer, then remove from heat immediately before it boils.|4. Squeeze the water out of the softened gelatin and stir it directly into the hot cream until dissolved completely.|5. Strain the liquid mixture through a fine sieve into individual serving molds or ramekins.|6. Refrigerate the molds for at least 4 hours until the cream sets into a delicate, wobbly consistency.|7. Unmold onto a plate and serve chilled, surrounded by a sweet-tart coulis made from simmered mixed berries.
3420	787	1	Press the fresh ricotta through a fine mesh sieve to eliminate lumps and create an ultra-smooth base.|2. Whisk the smooth ricotta with icing sugar, vanilla extract, and a pinch of orange zest until light and creamy.|3. Fold the mini dark chocolate chips or candied fruit pieces gently into the sweetened cheese filling.|4. Load the ricotta mixture into a piping bag fitted with a wide open tip.|5. Insert the piping bag into one end of a pre-baked cannoli shell and pipe the filling halfway through, then repeat from the other side.|6. Dip the exposed cream ends into a small bowl of chopped pistachios or extra chocolate chips.|7. Dust the pastry shell lightly with powdered sugar and serve immediately to ensure the shell stays perfectly crunchy.
3421	788	1	Melt the chopped dark chocolate pieces over a double boiler and let it cool down to room temperature.|2. Cream the softened butter and caster sugar together until light, pale, and fluffy.|3. Beat the egg yolks one by one into the butter mixture, followed by the melted chocolate and finely ground almonds.|4. Whip the egg whites in a separate clean bowl until they hold stiff, glossy peaks.|5. Gently fold the egg whites into the chocolate batter in three stages, keeping as much air as possible.|6. Pour the thick batter into a greased round cake tin and bake at 170°C for 40 to 45 minutes.|7. Cool completely in the tin (the cake will remain soft and fudgy in the center), then dust the top with powdered sugar.
3422	789	1	Heat the whole milk, heavy cream, and sugar together in a saucepan until the sugar dissolves completely.|2. Whisk the warm milk slowly into the egg yolks to temper them, then return to heat until it thickens slightly into a light custard base.|3. Remove from the heat and whisk in the roasted pistachio paste and a pinch of sea salt until uniform and smooth.|4. Chill the pistachio liquid mixture completely in the refrigerator for at least 4 hours.|5. Pour the cold pistachio base directly into an ice cream maker/churner.|6. Churn slowly to minimize the amount of air introduced, creating a dense, velvety texture characteristic of authentic gelato.|7. Transfer the churned gelato to a container and freeze for 2 hours to firm up before scooping.
3423	790	1	Place a small dessert bowl or wide-rimmed glass into the freezer for 10 minutes to chill thoroughly.|2. Scoop a large, firm ball of high-quality vanilla or fiordilatte gelato directly into the cold glass.|3. Brew a strong, concentrated single or double shot of hot espresso coffee using an espresso machine or moka pot.|4. Pour the hot espresso steadily directly over the cold gelato scoop right in front of the diner.|5. Watch as the hot coffee melts the outer layer of the cold gelato, creating a rich, creamy coffee foam at the base.|6. Top with a sprinkle of crushed amaretti cookies if desired, and serve immediately with a spoon.
3424	791	1	Mix the flour, sugar, eggs, orange zest, and vanilla extract together to form a soft, sticky dough.|2. Fold the whole toasted almonds directly into the dough paste by hand until they are evenly distributed.|3. Shape the sticky dough into long, flat log shapes on a baking tray lined with baking paper.|4. Bake at 180°C for 20 to 25 minutes until the logs are firm and pale golden.|5. Remove from the oven, let cool for 5 minutes, then slice the logs diagonally into 1cm thick biscuits using a serrated knife.|6. Arrange the sliced biscuits cut-side down back onto the tray and bake for another 10 minutes until completely dry and crunchy.|7. Serve cool alongside a small glass of Vin Santo for dipping.
3425	792	1	Dissolve sugar into hot water over medium heat to create a clear simple syrup, then mix it directly into the hot espresso.|2. Pour the sweetened coffee liquid into a shallow stainless steel pan or baking dish and let it cool completely.|3. Place the shallow pan into the freezer.|4. Every 30 minutes, use a fork to scrape the freezing edges inward, breaking up ice crystals to prevent a solid block from forming.|5. Repeat the scraping process for 2 to 3 hours until the mixture transforms into a fluffy mound of fine, separate coffee ice crystals.|6. Whip the heavy cream with a little sugar until it forms soft, pillowy peaks.|7. Layer the icy coffee granita into a glass, top it heavily with the fresh whipped cream, and serve with a spoon.
3426	793	1	Process the flour, sugar, lemon zest, and cold cubed butter into coarse crumbs, then add eggs to bind into a smooth dough ball; chill.|2. Roll out two-thirds of the chilled dough and press it neatly into the bottom and sides of a tart tin.|3. Spoon the fruit jam into the pastry base, spreading it into a thick, flat uniform layer.|4. Roll out the remaining dough and cut it into thin strips using a fluted pastry cutter wheel.|5. Arrange the dough strips over the jam layer in an alternating diagonal crisscross pattern to form a traditional lattice lid.|6. Crimp the outer edges tightly to seal the lattice strips securely to the base crust.|7. Bake at 180°C for 30 to 35 minutes until the pastry crust turns golden brown and the jam bubbles slightly.
3427	794	1	Build a rich, highly elastic yeast dough over multiple stages of rising and kneading to develop a complex gluten structure.|2. Incorporate the butter, egg yolks, honey, vanilla, candied citrus fruits, and soaked raisins thoroughly into the smooth dough.|3. Place the dough into a tall, cylindrical paper panettone mold and let it rise for 12 hours until it crowns the top rim.|4. Cut a shallow cross shape across the top surface of the dome using a razor blade and drop a small knob of butter into the center.|5. Bake at 170°C for 45 to 50 minutes until the interior is fully baked and the exterior dome turns a deep, glossy brown.|6. Skew the bottom of the baked bread instantly with metal rods and hang it completely upside down for 12 hours to prevent it from collapsing.
3429	796	1	Fill a large, wide-stemmed wine glass completely to the top with large ice cubes.|2. Pour the chilled Prosecco sparkling wine into the glass first, filling it roughly half full (3 parts).|3. Pour the Aperol liqueur directly over the prosecco in a circular motion (2 parts), matching the volumes.|4. Top up the remaining space with a quick splash of sparkling soda water (1 part).|5. Stir incredibly gently from the bottom up using a long bar spoon to integrate the layers without losing carbonation.|6. Drop a fresh slice of orange directly into the glass.|7. Serve ice-cold alongside light snacks.
3430	797	1	Wash the lemons thoroughly and peel the yellow skins using a peeler, taking care to avoid any bitter white pith.|2. Place the yellow lemon peels into a glass jar and pour the pure grain alcohol over them until fully submerged.|3. Seal the jar tightly and store it in a dark place for 7 to 10 days to extract the essential citrus oils completely.|4. Boil the water and sugar together in a pot until the sugar dissolves into a clear simple syrup; let cool to room temperature.|5. Strain the yellow alcohol liquid through a paper coffee filter to remove the spent pale peels.|6. Mix the infused alcohol with the cooled simple syrup, watching it turn an attractive, cloudy yellow color.|7. Bottle the liqueur and store it directly in the freezer, serving it ice-cold in small glasses after a meal.
3431	798	1	Place several large ice cubes into a clean mixing glass.|2. Pour equal parts gin, sweet red vermouth, and Campari directly over the ice cubes.|3. Stir the liquids continuously with a long bar spoon for 30 seconds to chill and dilute the cocktail perfectly.|4. Place one large, clear ice cube into a lowball rock glass (an Old Fashioned glass).|5. Strain the chilled red cocktail through a cocktail strainer into the serving glass over the ice cube.|6. Express the oils of a fresh orange peel strip over the surface of the drink by twisting it tightly.|7. Run the peel along the rim of the glass and drop it directly inside before serving.
3432	799	1	Select a lowball tumbler glass and fill it halfway with clean ice cubes.|2. Open a cold bottle of Chinotto soda and pour it slowly down the side of the glass to preserve the carbonation.|3. Watch the deep amber, cola-like liquid settle with a thick, brief head of tan foam.|4. Garnish the glass with a slice of fresh lemon or orange, which beautifully complements the herbal, citrus flavor profile.|5. Stir gently once using a straw.|6. Serve cold as a sophisticated, non-alcoholic alternative during afternoon breaks.
3433	800	1	Heat a generous amount of olive oil in a wide, shallow paella pan over medium-high heat.|2. Sear the chicken and rabbit pieces heavily until they are deeply browned and crispy on all sides.|3. Push the meat to the outer edges of the pan and sauté the green beans and lima beans in the center.|4. Stir in the grated tomatoes and sweet paprika, cooking down rapidly to create a rich flavor base (sofregit).|5. Pour in the hot stock and saffron liquid, bringing the entire pan to a vigorous rolling boil.|6. Sprinkle the Bomba rice evenly across the pan, stir once to distribute, and place a sprig of rosemary on top.|7. Cook undisturbed on high heat for 10 minutes, then lower to a simmer for 8 minutes until a crispy rice crust (socarrat) forms on the bottom.
3434	801	1	Heat a generous pool of olive oil in a deep skillet over medium heat.|2. Add the sliced potatoes and onions, ensuring they are completely submerged in the oil.|3. Poach the mixture slowly on low heat for 15 to 20 minutes until the potatoes are completely tender but not browned; drain well, reserving the oil.|4. Whisk the eggs vigorously with a generous pinch of sea salt in a large mixing bowl.|5. Fold the warm, drained potato and onion mixture gently into the beaten eggs, letting it sit for 10 minutes to absorb the liquid.|6. Heat two tablespoons of the reserved olive oil in a non-stick skillet over medium-high heat and pour in the egg mixture.|7. Cook for 2 minutes, then invert a large flat plate over the skillet, flip the tortilla quickly, slide it back in, and cook the second side until set.
3435	802	1	Pat the raw prawns completely dry using paper towels to ensure a beautiful sear.|2. Pour a generous layer of extra virgin olive oil into a small clay dish (cazuela) or a heavy skillet over medium-low heat.|3. Add the thinly sliced garlic and dried red chilis to the cold oil, letting them warm up slowly to infuse the oil with flavor.|4. Just as the garlic begins to turn a pale golden color, crank the heat up to high.|5. Toss the prawns directly into the sizzling garlic oil, cooking for exactly 1 minute on each side until they turn pink.|6. Pour in a quick splash of dry sherry wine, letting it bubble and reduce rapidly for 30 seconds.|7. Remove from the heat instantly, scatter the freshly chopped parsley across the top, and serve while still bubbling furiously.
3436	803	1	Place the beef brisket, pork belly, ham hock, and soaked chickpeas into a massive pot filled with cold water.|2. Bring to a boil, skim away any foam, then lower the heat and simmer gently for 2 hours.|3. Add the chopped carrots and potatoes to the pot, continuing to cook until tender.|4. In a separate pot, boil the cabbage along with the Spanish chorizo and morcilla sausages to prevent the main broth from turning red.|5. Strain the rich, savory meat broth out into a separate saucepan, add the fine noodles, and cook for 3 minutes to serve as the first course (sopa).|6. Serve the second course by piling the soft chickpeas, potatoes, and cabbage onto a large platter.|7. Carve the tender meats, chorizo, and morcilla, arranging them beautifully on a separate platter to enjoy as the final course.
3437	804	1	Bring a massive pot of water to a rolling boil along with a peeled whole onion.|2. Hold the octopus by its head and dip the tentacles into the boiling water three times to curl them neatly before submerging completely.|3. Lower the heat and simmer uncovered for 40 to 45 minutes until a knife slides easily into the thickest part of the tentacle.|4. Remove the octopus, let it rest for 10 minutes, then use kitchen shears to cut the tentacles into 1cm thick rounds.|5. Boil the thick potato slices directly in the remaining purple octopus water until fork-tender; drain well.|6. Arrange the hot potato slices flat across a traditional round wooden platter.|7. Layer the warm octopus pieces directly over the potatoes, drizzle heavily with olive oil, and dust generously with flaky salt and smoked paprika.
3438	805	1	Rub the entire surface of the lamb quarter heavily with coarse salt and a thin layer of lard.|2. Place the lamb skin-side down inside a wide, shallow earthenware baking dish (cazuela).|3. Pour a cup of water into the bottom of the dish around the meat, ensuring the liquid does not touch the seasoned skin.|4. Roast in a preheated oven at 160°C for 1.5 hours, basting the meat occasionally with the pan juices.|5. Carefully flip the lamb skin-side up to allow the exterior to crisp up beautifully.|6. Crank the oven temperature up to 200°C and roast for another 30 to 45 minutes.|7. Remove when the skin is blistered, thin, and golden brown, and the meat pulls effortlessly away from the bone.
3439	806	1	Combine the chopped tomatoes, green pepper, cucumber, garlic, and squeezed stale bread in a heavy-duty blender.|2. Blend on high speed for several minutes until the mixture turns into a completely liquid consistency.|3. While the blender is running on a medium speed, drizzle the extra virgin olive oil in a slow, steady stream.|4. Watch as the soup emulsifies, transforming from a deep red into a smooth, creamy orange-pink color.|5. Pour in the sherry vinegar and salt, adjusting the seasoning to achieve a perfect balance of acidity.|6. Pass the blended soup through a fine-mesh sieve into a glass pitcher to eliminate any remaining seeds or skin fragments.|7. Chill in the refrigerator for at least 4 hours and serve ice-cold in bowls or glasses topped with diced cucumbers.
3440	807	1	Place the soaked faba beans into a wide, heavy-bottomed pot and cover with cold water by 2 inches.|2. Add the whole onion, chorizo, morcilla, and pancetta directly into the pot with the beans.|3. Bring to a boil over high heat, skim off any foam, and drop in the saffron threads and a pinch of sweet paprika.|4. Lower the heat to a bare simmer, cover tightly, and let it cook slowly for 2 hours.|5. Never stir the pot with a spoon to avoid breaking the delicate beans; instead, swirl the entire pot gently by the handles.|6. Pour in a splash of cold water occasionally (asustar las alubias) to halt the boil and keep the bean skins tender.|7. Remove the meats, slice them into bite-sized portions, return them to the creamy beans, and serve warm.
3441	808	1	Season the pork cheeks heavily with salt and pepper, then dredge them lightly through a bowl of flour.|2. Heat olive oil in a heavy Dutch oven and sear the cheeks until a dark brown crust develops; remove.|3. Toss the diced onions, carrots, leeks, and garlic into the hot pan fat, sautéing until caramelized.|4. Pour in the entire bottle of red wine, scraping up the flavorful browned bits from the bottom of the pan.|5. Return the seared pork cheeks to the pot along with the stock, bay leaves, and a tiny piece of cinnamon stick.|6. Cover tightly and braise on low heat for 2 to 2.5 hours until the meat is incredibly tender.|7. Remove the cheeks, blend the remaining pan vegetables and wine into a silky, glossy gravy, and pour over the meat.
3442	809	1	Pat the desalted cod fillets completely dry with a clean kitchen towel.|2. Heat a generous layer of olive oil in a shallow clay dish, frying the sliced garlic and chili rings until golden; remove and set aside.|3. Lower the oil temperature until it is warm but not bubbling, and place the cod fillets in skin-side up.|4. Confat-cook the cod on ultra-low heat for 10 minutes, gently moving the pan in a continuous circular motion.|5. Flip the cod fillets skin-side down, allowing the gelatin from the fish skin to release into the warm oil.|6. Move the clay pan vigorously in flat circles across the stovetop, watching the white fish juices and golden oil blend together.|7. Continue swirling until a thick, creamy, pale-yellow mayonnaise-like emulsion forms, then top with the fried garlic.
3443	810	1	Mix the flour and a pinch of salt in a bowl, then pour in the boiling water, stirring rapidly to form a thick, sticky dough.|2. Load the warm dough into a sturdy pastry bag fitted with a star-shaped nozzle (the ridges are crucial to keep it from bursting).|3. Pipe long strips of dough directly into a deep pan of hot frying oil (180°C), cutting the ends with kitchen shears.|4. Fry for 3 to 4 minutes until the exterior turns an even, crispy golden brown; drain well on paper towels.|5. To make the dipping chocolate, heat milk and chopped dark chocolate in a saucepan, whisking until melted smooth.|6. Stir a teaspoon of cornstarch dissolved in milk into the chocolate, simmering until it thickens into a glossy paste.|7. Dust the hot churros heavily with granulated sugar and serve immediately alongside the warm chocolate cup.
3444	811	1	Infuse the whole milk in a saucepan with the cinnamon stick, lemon peel, and orange peel over medium heat until steaming; cool slightly.|2. Whisk the egg yolks and sugar together in a separate bowl until thick, pale, and creamy.|3. Dissolve the cornstarch into a small splash of cold milk, then stir it directly into the egg yolk mixture.|4. Strain the warm infused milk into the egg yolk bowl, whisking continuously to prevent the eggs from scrambling.|5. Pour the mixture back into the saucepan and cook over low heat, stirring constantly until it thickens into a smooth custard.|6. Divide the hot custard evenly into individual shallow clay dishes and let cool before refrigerating for 4 hours.|7. Dust the surface heavily with white sugar right before serving and torch it with a kitchen blowtorch to form a glass shell.
3445	812	1	Whisk the eggs and caster sugar together vigorously in a large mixing bowl until pale and fluffy.|2. Fold the finely ground almonds, fresh lemon zest, and ground cinnamon gently into the egg mixture until uniform.|3. Grease a round cake tin and line the bottom with parchment paper.|4. Pour the thick, fragrant almond batter into the tin, smoothing out the top surface with a spatula.|5. Bake in a preheated oven at 180°C for 35 to 40 minutes until the cake is firm and the top turns a golden brown.|6. Let the cake cool completely inside the tin before transferring it onto a beautiful serving platter.|7. Place a paper cutout of the Cross of Saint James in the center, dust heavily with powdered sugar, and carefully remove the stencil.
3446	813	1	Heat the whole milk, sugar, cinnamon stick, and lemon peel in a saucepan until boiling, then remove and let cool slightly.|2. Arrange the thick bread slices flat in a wide baking dish and pour the sweet infused milk evenly over them.|3. Let the bread sit undisturbed for 15 minutes until it absorbs the liquid completely and turns into a delicate custard.|4. Carefully lift each soaked bread slice, dredge it thoroughly through a bowl of beaten eggs, and let any excess drip off.|5. Pan-fry the coated slices in a skillet with hot olive oil or butter for 2 to 3 minutes on each side until golden brown.|6. Lift the hot torrijas out of the pan and roll them immediately through a shallow dish packed with cinnamon sugar.|7. Serve warm or at room temperature, offering a crispy exterior with a rich, melt-in-your-mouth interior.
3447	814	1	Line a deep springform cake tin completely with two overlapping sheets of parchment paper, letting the paper extend well above the rim.|2. Beat the softened cream cheese and caster sugar together in a large bowl until smooth and free of lumps.|3. Incorporate the eggs one by one, mixing gently to avoid beating too much air into the heavy batter.|4. Pour in the heavy whipping cream, salt, and flour, mixing just until the batter is glossy and uniform.|5. Pour the liquid batter into the prepared tin, tapping it on the counter to release any trapped air bubbles.|6. Bake in a very hot oven at 220°C for 40 to 45 minutes until the top is deeply caramelized and almost black.|7. Remove while the center is still incredibly jiggly; let cool completely at room temperature before slicing.
3448	815	1	Mash the fresh milk curds or ricotta cheese in a large mixing bowl using a fork until completely broken down.|2. Whisk the eggs and sugar into the cheese paste until light and well integrated.|3. Pour in the melted butter, fresh lemon zest, and ground cinnamon, stirring continuously.|4. Fold in the flour gradually until a thick, uniform batter forms.|5. Grease a shallow rectangular baking dish thoroughly with butter.|6. Pour the cheese batter into the dish, ensuring it forms a relatively thin layer about 2cm deep.|7. Bake at 180°C for 35 to 40 minutes until the top is a deep golden brown and the edges form a dense, pudding-like crust.
3449	816	1	Spread the flour evenly across a baking sheet and bake at 150°C for 15 minutes to toast it until pale ivory; cool completely.|2. Cream the lard and icing sugar together in a bowl until light, smooth, and fluffy.|3. Incorporate the toasted flour, ground almonds, and cinnamon into the lard paste, mixing until a crumbly dough forms.|4. Press the dough together into a flat disk, wrap it securely in plastic, and chill in the refrigerator for 30 minutes.|5. Roll the dough out gently to a thickness of 1.5cm, and cut out oval shapes using a cookie cutter.|6. Bake the fragile cookies on a lined tray at 180°C for 12 to 15 minutes (do not let them brown too much).|7. Let them cool completely on the tray before touching them, then dust heavily with powdered sugar and wrap in tissue paper.
3450	817	1	Infuse the milk with the cinnamon stick and lemon peel over medium heat until warm, then strain out the solids.|2. Whisk the sugar, cornstarch, and flour into the warm milk, returning it to low heat while stirring constantly.|3. Cook until the milk mixture transforms into a dense, thick, and smooth paste.|4. Grease a shallow rectangular glass dish and pour the thick custard inside, smoothing it out to a 2cm thickness; chill for 4 hours.|5. Once the custard has set firm, slice it neatly into uniform square or diamond shapes using a sharp knife.|6. Dredge each cold custard square through flour, dip it into beaten eggs, and shallow fry in hot oil until crispy and golden.|7. Drain quickly, toss immediately in a plate of cinnamon sugar, and serve warm.
3451	818	1	Boil sugar and water in a saucepan over medium heat until it forms a deep, amber-colored liquid caramel.|2. Pour the hot caramel quickly into the base of individual aluminum ramekins or a loaf tin, tilting to coat the sides; let cool.|3. Boil the remaining sugar and water together for 5 minutes to create a thick, clear simple syrup; let cool to lukewarm.|4. Whisk the egg yolks gently in a bowl without creating any foam or air bubbles.|5. Slowly pour the lukewarm sugar syrup into the egg yolks in a thin stream, stirring continuously until smooth.|6. Strain the yolk mixture through a fine sieve directly into the caramelized molds to eliminate any lumps.|7. Bake in a water bath (baño María) covered with foil at 160°C for 30 minutes until set, then chill thoroughly before unmolding.
3452	819	1	Knead the flour, water, sugar, eggs, and yeast together for 15 minutes to develop an elastic dough; let rise for 2 hours.|2. Roll out a portion of the dough on an oiled surface until it is paper-thin and almost translucent.|3. Spread a generous, uniform layer of soft pork lard completely across the entire surface of the thin dough sheet.|4. Roll the dough up tightly from the long edge to form a long, thin sausage-shaped rope.|5. Coil the dough rope loosely on a baking sheet in a clock-wise spiral pattern, leaving space between the coils for expansion.|6. Let the pastry spiral rise undisturbed in a warm spot for 12 hours until it puffs up and fills the gaps.|7. Bake at 180°C for 15 minutes until golden brown, and dust with a heavy blanket of powdered sugar once cool.
3453	820	1	Chop the fresh apples, oranges, and lemons into small cubes or thin slices.|2. Place the chopped fruit into the bottom of a massive glass pitcher.|3. Pour the brandy and simple syrup over the fruit, pressing lightly with a wooden spoon to release the natural juices.|4. Pour the entire bottle of red wine into the pitcher, dropping in a cinnamon stick.|5. Stir the mixture thoroughly with a long bar spoon to ensure the sugar is integrated.|6. Place the pitcher into the refrigerator for at least 4 hours (preferably overnight) to let the flavors marinate.|7. Serve ice-cold in wine glasses filled with ice cubes, topping with a splash of soda water right before pouring if desired.
3454	821	1	Select a small, clear glass espresso cup or demitasse glass to showcase the distinct layers.|2. Pour sweetened condensed milk into the bottom of the clear glass, filling it exactly halfway up.|3. Brew a strong, concentrated shot of hot espresso coffee using an espresso machine or a moka pot.|4. Pour the hot espresso slowly and carefully directly over the condensed milk.|5. Watch as the dark coffee floats perfectly on top of the dense white milk, creating a sharp, clean visual line.|6. Serve the beverage undisturbed along with a small spoon.|7. Stir the layers together thoroughly right before drinking to blend into a rich, sweet caramel-colored treat.
3455	822	1	Fill a tall, wide highball glass or a wine goblet completely to the brim with large ice cubes.|2. Pour the red wine into the glass, filling it exactly halfway up (1 part).|3. Top up the remaining half of the glass with ice-cold lemon-lime soda or carbonated lemonade (1 part).|4. Stir gently using a long spoon from the bottom up to integrate the wine and soda without losing bubbles.|5. Garnish the glass with a fresh slice of lemon or orange.|6. Serve ice-cold on hot summer afternoons alongside savory tapas.
3456	823	1	Soak the dried tiger nuts in a massive bowl of cold water for 24 hours, changing the water once.|2. Drain and rinse the plumped tiger nuts thoroughly under cold running water.|3. Place the soaked nuts into a high-powered blender along with half of the fresh cold water.|4. Blend on high speed for several minutes until a fine, milky paste forms.|5. Pour the blended mixture through a fine cheesecloth or nut milk bag, squeezing hard to extract every drop of liquid.|6. Stir the caster sugar and a tiny pinch of cinnamon into the extracted white milk until dissolved completely.|7. Add the remaining cold water, chill in the freezer until partially frozen and icy, and stir well before serving.
3457	824	1	Chop a lemon wedge and set it aside, ensuring your serving glass is thoroughly chilled.|2. Tilt a tall beer glass to a 45-degree angle to control the foam layer.|3. Pour the cold carbonated lemon soda into the glass until it is half full.|4. Top up the remaining space slowly with the cold pale lager beer, straightening the glass to build a clean head of foam.|5. Watch as the pale yellow liquids blend seamlessly together into a bright, refreshing shandy.|6. Drop the fresh lemon wedge into the glass or place it on the rim.|7. Serve ice-cold as a crisp refresher during afternoon breaks or hot terrace lunches.
3458	825	1	Trim the brisket's hard fat cap down to a uniform 6mm thickness to allow the smoke to penetrate evenly.|2. Mix equal parts coarse sea salt and coarse black pepper thoroughly in a bowl.|3. Coat the entire surface of the brisket heavily and evenly with the salt and pepper rub.|4. Preheat your offset smoker to 110°C using post oak wood to establish a clean, blue smoke.|5. Place the brisket inside the smoker fat-side up, close the lid, and smoke continuously for 6 hours.|6. Spritz the meat with a little water or apple cider vinegar every hour to keep the surface moist.|7. Once the internal temperature hits 74°C and a dark crust forms, wrap the brisket tightly in pink butcher paper, return to the smoker, and cook until it reaches 95°C; rest for 2 hours before slicing.
3459	826	1	Whisk the buttermilk, hot sauce, salt, and a tablespoon of the seasoning blend together in a massive bowl.|2. Submerge the chicken pieces entirely in the buttermilk mixture, cover tightly, and brine in the refrigerator for at least 4 hours.|3. Combine the all-purpose flour, cornstarch, and the remaining seasoning blend in a large brown paper bag or shallow dish.|4. Lift a piece of chicken from the buttermilk, let the excess drip off, and dredge it heavily through the seasoned flour.|5. Press the flour firmly onto the meat to create jagged edges that will fry up ultra-crispy.|6. Heat peanut oil in a deep cast-iron skillet until it reaches exactly 175°C.|7. Fry the chicken in small batches for 12 to 15 minutes, turning once, until the crust is deeply golden and the internal temperature reads 74°C.
3460	827	1	Whisk the mayonnaise, beaten egg, Dijon mustard, Worcestershire sauce, and Old Bay seasoning together in a small bowl until completely smooth.|2. Place the lump crab meat into a large bowl, scattering the finely crushed saltine cracker crumbs across the top.|3. Pour the prepared mayonnaise mixture over the crab meat and crackers.|4. Use a rubber spatula or clean hands to fold the mixture together with extreme care, keeping the large crab lumps intact.|5. Shape the delicate mixture into 6 large, thick uniform rounds without pressing or compacting the meat tightly.|6. Arrange the crab cakes on a lined baking sheet, brush the tops generously with melted butter, and chill for 30 minutes.|7. Broil under a hot oven broiler at 220°C for 10 to 12 minutes until the tops turn a beautiful speckled golden brown.
3461	828	1	Fry the diced bacon lardons in a heavy-bottomed Dutch oven until they turn crispy and render their fat; remove bacon and set aside.|2. Sauté the diced onions and celery in the hot bacon fat over medium heat until soft and translucent.|3. Sprinkle flour over the vegetables, stirring constantly for 2 minutes to cook out the raw flour taste.|4. Slowly whisk in the reserved clam juice and whole milk, stirring vigorously to avoid any hidden flour lumps.|5. Drop the diced potatoes, fresh thyme sprig, and bay leaf into the pot, bringing the liquid to a gentle boil.|6. Lower the heat and simmer uncovered for 15 minutes until the potatoes are fork-tender.|7. Stir in the chopped clams and heavy cream, cooking on low heat for an additional 5 minutes until hot throughout, and top with the crispy bacon.
3462	829	1	Pat the chicken wings completely dry with paper towels (moisture prevents a crispy skin).|2. Heat a deep fryer filled with vegetable oil to 190°C.|3. Melt the unsalted butter in a small saucepan over low heat, whisking in the cayenne pepper hot sauce, vinegar, and garlic powder until smooth.|4. Drop the dry chicken wings carefully into the hot oil in batches.|5. Deep-fry the wings undisturbed for 12 to 15 minutes until the skin turns completely crispy and rigid.|6. Lift the wings from the oil, drain briefly on a wire rack, and transfer them immediately into a massive stainless steel bowl.|7. Pour the warm Buffalo sauce over the hot wings, tossing them vigorously until coated uniformly, and serve warm with celery and blue cheese.
3463	830	1	Brown the sliced andouille sausage rounds in a large, heavy Dutch oven until crispy; remove and keep the fat in the pot.|2. Sear the seasoned chicken thigh pieces in the remaining sausage fat until golden brown; remove.|3. Toss the diced onion, green pepper, and celery into the hot pot, sautéing until soft.|4. Stir in the minced garlic, Cajun spice blend, and crushed tomatoes, cooking down for 3 minutes to build a rich flavor base.|5. Pour the long-grain raw white rice into the pot, stirring for 1 minute to coat the grains thoroughly in the oil and spices.|6. Return the chicken and sausage to the pot, pour in the chicken stock, and bring to a rolling boil.|7. Cover tightly, lower the heat to a simmer, and cook for 20 minutes; push the shrimp into the top rice layer during the final 5 minutes until pink.
3464	831	1	Heat a heavy cast-iron griddle or flat top skillet over high heat with a splash of oil.|2. Add the sliced onions to one side of the griddle, sautéing until soft and lightly caramelized; push to the corner.|3. Place the paper-thin shaved ribeye steak directly onto the hottest part of the griddle.|4. Use two metal spatulas to rapidly chop and shred the meat as it sears, cooking for just 2 minutes until no pink remains.|5. Mix the caramelized onions directly into the shredded beef, shaping the mixture into a long rectangle matching the length of the roll.|6. Lay the Provolone slices (or pour melted Cheez Whiz) directly over the hot meat mound, letting it melt completely.|7. Slice the hoagie roll open, place it face-down directly over the cheesy meat mound, scoop everything up cleanly with a spatula, and flip upright.
3465	832	1	Grease a deep, round cake-style pizza pan heavily with butter or olive oil.|2. Roll out the yellow cornmeal dough and press it firmly into the bottom and up the tall sides of the pan.|3. Lay a dense, overlapping blanket of sliced mozzarella cheese directly across the raw dough base (this prevents soggy dough).|4. Press a continuous, flat sheet of raw Italian sausage meat directly over the mozzarella cheese layer.|5. Ladle a thick, heavy blanket of the chunky tomato sauce completely over the sausage layer, smoothing it flat.|6. Sprinkle the top heavily with grated Pecorino Romano cheese and a drizzle of olive oil.|7. Bake at 220°C for 35 to 40 minutes until the crust is golden-brown and the top sauce layer is bubbling and slightly caramelized.
3466	833	1	Bring the milk, water, and chicken stock to a boil in a saucepan, whisk in the grits slowly, and lower the heat to a simmer.|2. Cook the grits for 45 minutes, stirring frequently until thick and creamy, then beat in butter and grated cheddar cheese.|3. Fry the diced bacon pieces in a separate heavy skillet until crispy; remove the bacon pieces, keeping the fat in the pan.|4. Sauté the diced bell pepper, onions, and minced garlic in the hot bacon fat until soft and aromatic.|5. Toss the shrimp into the skillet, seasoning with salt and pepper, and sauté for 2 to 3 minutes until they curl.|6. Pour in a small splash of chicken stock and lemon juice, scraping the pan bottom to create a light, savory pan gravy.|7. Spoon the hot, cheesy grits into a wide bowl, layer the shrimp and gravy over the top, and garnish with the crispy bacon and green onions.
3467	834	1	Sauté the finely minced onions and garlic in a pan with butter until soft and cool completely.|2. Mix the ground beef, breadcrumbs, milk, eggs, cooled onions, Worcestershire sauce, salt, and pepper together thoroughly in a massive bowl using your hands.|3. Whisk the ketchup, dark brown sugar, and apple cider vinegar together in a small bowl to create the sweet glaze.|4. Pack the meat mixture firmly into a greased bread loaf tin, smoothing out the top surface flat.|5. Bake in a preheated oven at 175°C for 40 minutes.|6. Remove the meatloaf briefly, pour off any excess grease, and brush the sweet ketchup glaze heavily across the top surface.|7. Return to the oven for another 15 to 20 minutes until the glaze turns sticky and caramelized and the internal temperature reads 71°C.
3468	835	1	Mix the graham crumbs, sugar, and melted butter, press tightly into the base of a springform pan, and bake for 10 minutes; cool.|2. Beat the softened cream cheese and sugar together on low speed for 5 minutes until perfectly smooth and free of lumps.|3. Mix in the flour, sour cream, vanilla extract, and lemon zest until just integrated.|4. Add the eggs one at a time, mixing gently on low speed to avoid trapping excessive air bubbles into the dense batter.|5. Pour the heavy cheese filling over the cooled crust, wrapping the exterior of the pan tightly in heavy-duty aluminum foil.|6. Place the springform pan inside a large roasting pan filled with boiling water (baño maría) to ensure even baking.|7. Bake at 160°C for 1 hour and 15 minutes, then let it cool inside the turned-off oven for 1 hour before refrigerating overnight.
3469	836	1	Toss the sliced tart apples with the lemon juice, sugars, flour, cinnamon, and nutmeg in a large bowl; let sit for 20 minutes.|2. Line a deep pie dish with the first rolled pastry sheet, allowing the excess to hang over the edges cleanly.|3. Mound the spiced apple slices tightly into the pastry shell, stacking them slightly higher in the absolute center.|4. Roll out the second pastry sheet, cut it into long ribbons, and weave a traditional lattice top (or lay it whole, cutting large vent slits).|5. Crimp and flute the borders tightly using your fingers to lock the crust layers together securely.|6. Brush the pastry lid evenly with egg wash and sprinkle generously with coarse sanding sugar.|7. Bake at 200°C for 20 minutes, then lower the oven heat to 180°C and bake for another 40 minutes until the fruit juices bubble thickly.
3470	837	1	Whisk the melted butter, granulated sugar, and brown sugar together vigorously in a large mixing bowl for 2 minutes.|2. Beat the eggs and vanilla extract into the sugar mixture until pale, fluffy, and slightly expanded (this creates the shiny, crackly skin).|3. Whisk in the melted dark chocolate chunks until smooth and glossy.|4. Gently fold in the flour, cocoa powder, and sea salt using a rubber spatula just until the dry ingredients disappear.|5. Pour the thick, heavy chocolate batter into a square baking pan lined with parchment paper, smoothing the surface.|6. Bake at 160°C for 22 to 25 minutes (do not overbake; the center should remain slightly soft and fudgy).|7. Remove from the oven, sprinkle with flaky sea salt if desired, and cool completely in the pan before cutting into squares.
3471	838	1	Whisk the flour, baking soda, and salt together in a small bowl; set aside.|2. Cream the softened butter, granulated sugar, and dark brown sugar together in a stand mixer until light and fluffy.|3. Add the eggs one at a time, beating thoroughly after each addition, followed by the vanilla extract.|4. Turn the mixer to low and fold in the dry flour mixture gradually just until a soft cookie dough forms.|5. Stir the semi-sweet chocolate chips into the dough uniformly using a wooden spoon.|6. Scoop the cookie dough into large balls, place them on a tray, and chill in the refrigerator for at least 2 hours (this prevents spreading).|7. Arrange the cold dough balls on a lined baking sheet and bake at 190°C for 10 to 12 minutes until the edges are golden but the centers remain soft.
3472	839	1	Combine the graham crumbs, sugar, and melted butter, pressing the mixture firmly into a pie dish, and bake for 8 minutes; cool completely.|2. Whisk the egg yolks and fresh lime zest together in a large mixing bowl until pale and slightly thick.|3. Pour in the sweetened condensed milk, whisking continuously on medium speed until smooth.|4. Gradually add the fresh Key lime juice, stirring gently (the acid in the lime juice reacts with the milk proteins, thickening it instantly).|5. Pour the smooth, pale yellow lime filling directly into the baked graham cracker crust.|6. Bake at 175°C for 15 minutes just until the center is set but still jiggles slightly when nudged.|7. Cool to room temperature, refrigerate for at least 4 hours to firm up, and pipe fresh whipped cream rosettes along the border before serving.
3473	840	1	Roll out the pastry sheet and press it neatly into a pie dish, crimping the upper borders beautifully; chill.|2. Whisk the dark brown sugar, dark corn syrup, melted butter, eggs, vanilla extract, and salt together in a bowl until smooth.|3. Scatter the toasted pecan halves evenly across the bottom of the raw, chilled pastry shell.|4. Pour the sweet liquid sugar mixture carefully directly over the pecan halves.|5. Watch as the pecan halves naturally float cleanly to the surface, creating a beautiful, uniform mosaic layer.|6. Bake in a preheated oven at 175°C for 50 to 55 minutes.|7. Remove when the outer edges of the pie filling are puffed and set, and the center jiggles only slightly; cool completely before slicing.
3474	841	1	Toss the sliced peaches, sugars, cornstarch, and fresh lemon juice together in a saucepan, simmering for 5 minutes until a light syrup forms.|2. Pour the warm peaches and syrup directly into the bottom of a greased rectangular baking dish.|3. Whisk the flour, sugar, and baking powder together, then cut in the cold cubed butter using your fingers until coarse crumbs form.|4. Stir in the boiling water or buttermilk quickly just until a soft, sticky drop-biscuit dough comes together.|5. Spoon large mounds of the biscuit dough across the top of the hot peaches, leaving small gaps for steam to escape.|6. Sprinkle the biscuit tops with extra sugar and a dash of cinnamon.|7. Bake at 190°C for 35 to 40 minutes until the peach juices bubble violently and the biscuit topping turns deep golden brown.
3475	842	1	Whisk the sugar, vegetable oil, and eggs together in a large bowl until smooth and pale.|2. Stir the red food coloring and cocoa powder into the wet mixture thoroughly to build a deep, dark red base paste.|3. Alternately add the cake flour and buttermilk in stages, mixing gently on low speed to maintain a light crumb.|4. Mix the baking soda and white vinegar together in a small cup (it will fizz rapidly) and fold it instantly into the cake batter.|5. Divide the batter between two greased round cake tins and bake at 175°C for 30 minutes; cool completely.|6. Whip the cream cheese, butter, and icing sugar together until a thick, fluffy, snow-white frosting forms.|7. Layer and coat the crimson cake layers completely with the white frosting, leaving a dramatic color contrast when sliced.
3476	843	1	Whisk the milk, sugar, cornstarch, and egg yolks together in a saucepan over medium heat, stirring constantly until thick.|2. Remove from the heat, stir in the vanilla extract and a knob of butter, and let the custard cool completely to room temperature.|3. Select a large glass trifle bowl or rectangular dish to showcase the distinct layers.|4. Arrange a single layer of crisp vanilla wafer cookies tightly across the bottom of the serving dish.|5. Layer fresh banana slices directly over the cookies, followed by a heavy blanket of the cooled vanilla custard.|6. Repeat the wafer, banana, and custard layering process until the dish is filled to the top rim.|7. Whip heavy cream until stiff peaks form, spread it smoothly across the top, and chill for 4 hours until the cookies soften into a cake-like texture.
3477	844	1	Mix the Oreo crumbs and melted butter, press firmly into a deep pie dish, and bake for 8 minutes; cool.|2. Melt the bittersweet chocolate and butter together, then whisk in eggs and sugar until smooth.|3. Pour the chocolate egg mixture into the Oreo crust and bake at 160°C for 25 minutes until set like a fudgy brownie base; cool completely.|4. Prepare your thick chocolate pudding and spread it smoothly directly over the cooled brownie cake layer.|5. Place the pie into the refrigerator for 3 hours to allow the pudding layer to set completely firm.|6. Top the pie heavily with a thick blanket of freshly whipped cream.|7. Decorate the top surface with dark chocolate curls or shavings before slicing and serving cold.
3478	845	1	Bring 4 cups of fresh water to a rolling boil in a large saucepan.|2. Remove from heat, drop the black tea bags and a tiny pinch of baking soda into the water, and steep for 15 minutes.|3. Remove and discard the spent tea bags without squeezing them to avoid releasing bitter flavors.|4. Pour the granulated white sugar directly into the hot tea liquid immediately, stirring vigorously until completely dissolved.|5. Pour the sweet concentrated tea into a large pitcher, adding 4 cups of cold water to dilute it perfectly.|6. Place the pitcher into the refrigerator to chill completely for at least 2 hours.|7. Serve ice-cold in tall glasses packed to the brim with ice cubes, garnished with a fresh lemon wheel.
3479	846	1	Place the single sugar cube into the bottom of a heavy rock glass (an Old Fashioned glass).|2. Saturate the sugar cube directly with 3 heavy dashes of Angostura aromatic bitters.|3. Add a quick splash of warm water and muddle thoroughly with a wooden muddler until the sugar dissolves completely into a paste.|4. Pour the bourbon or rye whiskey shot directly over the dissolved sugar base.|5. Place one large, clear ice sphere carefully into the center of the glass.|6. Stir the drink gently with a long bar spoon for 20 seconds to chill and dilute the spirits smoothly.|7. Express the oils of a fresh orange peel strip over the glass rim, twist it tightly, and drop it directly inside the cocktail.
3480	847	1	Place a large, thick glass beer mug or soda fountain glass into the freezer for 15 minutes to chill thoroughly.|2. Scoop 2 large, firm balls of vanilla bean ice cream carefully into the bottom of the frozen mug.|3. Open the ice-cold root beer soda and begin pouring it very slowly down the inner side of the glass.|4. Watch closely as the carbonated root beer hits the cold ice cream, creating a massive, thick head of rich, tan foam.|5. Pause for 10 seconds to allow the foam head to settle slightly, then top up the glass with the remaining soda.|6. Serve immediately accompanied by a long straw and a tall spoon to enjoy the melting cream layers.
3481	848	1	Place 8 to 10 fresh mint leaves and the simple syrup into the bottom of a traditional silver or pewter Julep cup.|2. Use a wooden muddler to press down gently on the mint leaves to release their essential oils (do not shred the leaves, or they turn bitter).|3. Pack the julep cup completely to the top rim with crushed ice, creating a small dome of ice at the surface.|4. Pour the Kentucky bourbon steadily directly over the crushed ice mound.|5. Use a long bar spoon to stir the drink vigorously from the bottom up until the exterior of the silver cup forms a thick layer of white frost.|6. Slap a fresh sprig of mint firmly against your hand to release its aroma and tuck it deeply into the ice next to the straw.|7. Serve immediately while frosted ice-cold.
3482	849	1	Pour the unfiltered cloudy apple cider juice into a deep, stainless steel boiling pot over medium heat.|2. Drop the cinnamon sticks, whole cloves, and allspice berries directly into the juice.|3. Float the fresh orange slices across the surface of the liquid.|4. Bring the mixture to a brief boil, then reduce the heat to low immediately.|5. Cover tightly with a lid and let the spiced cider simmer gently for 30 minutes to allow the spices to infuse deeply.|6. Turn off the heat and strain the hot liquid through a fine sieve to remove the spent spices and fruit slices.|7. Ladle the steaming beverage into heavy ceramic mugs, grating a dust of fresh nutmeg over the top before serving.
3483	850	1	Stem, seed, and tear the dried chilies into pieces, then fry them quickly in hot lard until fragrant but not burnt; remove and soak in hot broth.|2. In the same lard, fry the chopped onions, garlic, plantains, raisins, nuts, seeds, and spices until beautifully toasted.|3. Char the corn tortillas completely, tear them into pieces, and add them to the mixture along with the soaked chilies and their liquid.|4. Blend everything in batches on high speed until a perfectly smooth, thick paste forms.|5. Melt a tablespoon of lard in a heavy clay pot (cazuela), add the blended paste, and cook on low heat, stirring continuously to prevent sticking.|6. Stir in the chopped Mexican chocolate and extra chicken broth, simmering slowly for 45 minutes until the sauce turns thick and glossy.|7. Add the cooked chicken pieces to the bubbling sauce, coat them thoroughly, and serve hot topped with toasted sesame seeds.
3484	851	1	Blend the rehydrated chilies, achiote paste, garlic, vinegar, pineapple juice, and spices together until a smooth, vibrant red marinade forms.|2. Coat the thin pork slices heavily with the marinade, cover tightly, and refrigerate for at least 4 hours (preferably overnight).|3. Stack the marinated pork slices tightly onto a vertical skewer, capping the top with a large chunk of fresh pineapple (trompo).|4. Roast the meat tower slowly in front of an open flame or in a hot oven until the outer edges turn deeply caramelized and crispy.|5. Use a sharp knife to shave the hot pork directly off the spit into thin, crispy ribbons.|6. Warm the fresh corn tortillas on a hot griddle pan (comal) until soft and pliable.|7. Pile the warm shaved pork onto the tortillas, slice a small piece of pineapple from the top of the spit over the meat, and garnish with diced onions and cilantro.
3485	852	1	Char the skin of the Poblano peppers over an open flame until completely black, place them in a plastic bag to steam, then peel and deseed carefully through a small slit.|2. Sauté the onions and garlic in a pan, add the ground pork and beef, and cook until browned while breaking up any large meat clumps.|3. Stir in the diced fruits, raisins, almonds, pine nuts, and a splash of broth, simmering until the liquid evaporates and the meat filling is thick and savory.|4. To make the nogada sauce, blend the soaked walnuts, queso fresco, heavy cream, sherry wine, and a pinch of sugar until velvety smooth and cold.|5. Stuff the roasted Poblano peppers tightly with the cooled sweet-savory meat filling, reshaping them neatly.|6. Place the stuffed peppers flat on a serving platter and cover them completely with a heavy, thick layer of the cold walnut cream sauce.|7. Scatter the bright red pomegranate seeds and finely chopped green parsley across the top to mirror the vibrant colors of the Mexican flag.
3486	853	1	Place the pork shanks, pork shoulder chunks, half a whole onion, and a head of garlic into a massive boiling pot filled with water.|2. Bring to a rolling boil, skim off any foam that rises to the surface, cover tightly, and simmer on low heat for 1.5 hours until the pork is fork-tender.|3. Boil the dried Guajillo and Ancho chilies in a separate pan until soft, then blend them with garlic and a cup of the cooking broth until smooth; strain the red liquid.|4. Remove the tender pork from the main pot, shred the meat coarsely into bite-sized pieces, and discard the bone fragments and boiled onion halves.|5. Pour the strained red chili paste and the rinsed white hominy kernels directly into the simmering pork broth.|6. Return the shredded pork to the pot, season heavily with Mexican oregano and salt, and simmer uncovered for an additional 30 minutes until the corn kernels "bloom".|7. Ladle the piping hot red soup into wide bowls and serve hot alongside plates of shredded cabbage, sliced radishes, lime, and crispy corn tostadas.
3487	854	1	Melt the pure lard in a massive, heavy copper or cast-iron pot (cazo) over medium heat until entirely liquid.|2. Add the large pork shoulder cubes carefully into the hot lard, ensuring the meat is completely submerged.|3. Squeeze the juice of the fresh orange halves directly into the lard, dropping the spent peels right into the pot.|4. Stir in the condensed milk, whole garlic cloves, onion quarters, bay leaves, oregano, and a splash of Coca-Cola or beer.|5. Lower the heat to a gentle simmer and cook uncovered for 2 to 2.5 hours, letting the moisture evaporate slowly while the pork configuration breaks down.|6. Once the meat is melt-in-your-mouth tender, crank the heat to high to boil off any remaining water, flash-frying the pork in the hot lard for 10 minutes.|7. Remove the pork when the exterior edges turn deeply browned and shatteringly crisp; chop coarsely and serve hot as a taco filling.
3488	855	1	Blend the achiote paste, bitter orange juice, mashed garlic, oregano, cumin, and allspice together in a blender until smooth.|2. Pour the bright red marinade over the pork chunks, rubbing it into the meat thoroughly, and let marinate in the refrigerator overnight.|3. Line a deep baking dish or Dutch oven with overlapping sheets of softened banana leaves, leaving plenty of overhang on the sides.|4. Place the marinated pork chunks and any remaining liquid into the center of the banana leaf bed.|5. Fold the overlapping banana leaves tightly over the pork to seal it completely, trapping all the moisture and aromatics inside.|6. Cover the baking dish tightly with aluminum foil or a heavy lid and bake at 150°C for 3.5 to 4 hours until the pork is structural jelly.|7. Unwrap the banana leaves carefully, shred the meat thoroughly using two forks into its own bright red juices, and top with pickled red onions.
3489	856	1	Boil or roast the fresh tomatillos, serrano peppers, half an onion, and garlic cloves until they are soft and slightly charred.|2. Transfer the cooked vegetables into a blender along with a massive handful of fresh cilantro and a cup of chicken broth; blend until smooth.|3. Pour the green salsa into a saucepan with a tablespoon of oil, bring to a simmer, and cook for 10 minutes until thick and vibrant.|4. Flash-fry each corn tortilla in hot oil for exactly 5 seconds on each side just to soften them up and make them pliable without turning crispy.|5. Dip the warm tortilla into the green salsa, fill the center with a generous handful of shredded chicken, and roll it up tightly.|6. Arrange the rolled tortillas seam-side down in a baking dish or directly onto a serving plate.|7. Ladle a heavy, steaming layer of the green salsa completely over the tortillas, and garnish with Mexican crema, crumbled queso fresco, and thin onion rings.
3490	857	1	Blend the rehydrated chilies, roasted tomatoes, garlic, onion, vinegar, and all the spices together into a thick, highly aromatic marinade; strain if necessary.|2. Coat the beef cuts heavily with the red marinade, transfer to a heavy Dutch oven, and pour in enough beef stock to cover the meat.|3. Cover tightly and simmer on ultra-low heat for 3.5 to 4 hours (or bake at 150°C) until the beef pulls away from the bone completely.|4. Remove the meat from the pot, shred it finely, and skim the vibrant red fat layer floating on top of the broth (consomé) into a bowl.|5. To make the famous tacos, dip a corn tortilla directly into the skimmed red beef fat and place it flat onto a hot griddle pan.|6. Scatter melting cheese and a generous handful of the shredded beef over one half of the tortilla, fold it over, and fry until crispy.|7. Serve the crispy tacos hot alongside a small bowl of the clear hot beef broth topped with chopped onions and cilantro for dipping.
3491	858	1	Deep-fry the stale corn tortilla triangles in hot oil until they turn ultra-crispy and golden brown; drain well on paper towels and salt lightly.|2. Boil the tomatoes and Guajillo chilies until soft, then blend them with garlic and onion until smooth.|3. Pour the red sauce into a hot skillet with a splash of oil, drop in the epazote sprig, and simmer for 10 minutes until deep red and thick.|4. Toss the crispy fried tortilla chips directly into the bubbling pan of red sauce over medium heat.|5. Gently stir the chips for 1 to 2 minutes, ensuring every single piece is thoroughly coated in the sauce while retaining a slight structural crunch.|6. Transfer the coated tortilla chips immediately onto a wide serving plate.|7. Drizzle heavily with Mexican crema, sprinkle with crumbled Cotija cheese and sliced onions, and top with a fried egg if desired.
3492	859	1	Arrange the butterflied raw shrimp flat in a single layer across a wide, cold ceramic serving platter; season lightly with sea salt.|2. To make the green curing liquid, blend the fresh lime juice, serrano peppers, and a massive handful of fresh cilantro until completely liquid and vibrant green.|3. Scatter the half-moon cucumber slices and paper-thin red onion ribbons evenly over the raw shrimp layer.|4. Pour the cold green chili-lime liquid steadily over the entire platter, ensuring all the shrimp are submerged in the acid.|5. Let the platter sit undisturbed at room temperature for exactly 5 to 10 minutes (no longer, or the shrimp will turn tough).|6. Watch as the shrimp flash-cure in the lime juice, turning slightly opaque on the exterior edges while remaining sweet and tender inside.|7. Garnish the platter with fresh avocado slices and serve immediately ice-cold accompanied by crispy corn tostadas.
3493	860	1	Melt white sugar in a heavy saucepan over medium heat, stirring continuously until it liquefies into a clear, dark amber caramel.|2. Pour the hot liquid caramel quickly into the base of a round metal baking mold (flanera), tilting the mold to coat the bottom uniformly; let cool.|3. Combine the condensed milk, evaporated milk, eggs, cream cheese, and a generous splash of vanilla extract in a blender.|4. Blend on medium speed for 1 minute until completely smooth and free of air bubbles.|5. Strain the liquid custard mixture through a fine-mesh sieve directly into the caramelized mold over the hard sugar shell.|6. Cover the mold tightly with aluminum foil and place it inside a large baking pan filled with boiling water (baño María).|7. Bake at 175°C for 50 to 60 minutes until the edges are set but the center remains slightly jiggly; chill in the refrigerator overnight before flipping onto a plate.
3494	861	1	Beat the egg yolks with sugar until pale and thick, fold in the flour, then gently fold in stiffly beaten egg whites to maintain a fluffy batter.|2. Pour into a greased rectangular baking dish and bake at 175°C for 25 to 30 minutes until a toothpick comes out dry; let cool.|3. Whisk the sweetened condensed milk, evaporated milk, and heavy whipping cream together in a pitcher along with a teaspoon of vanilla extract.|4. Use a fork to pierce the entire surface of the cooled sponge cake with dozens of deep holes from edge to edge.|5. Pour the three-milk mixture slowly and evenly across the cake, allowing the dry sponge to completely drink up the sweet liquid.|6. Cover the dish tightly with plastic wrap and transfer to the refrigerator to chill for at least 4 hours (preferably overnight) to set.|7. Whip extra heavy cream and powdered sugar until stiff, spread it smoothly over the soaked cake, and dust with ground cinnamon.
3495	862	1	Bring water, butter, and salt to a boil in a saucepan, dump in the flour all at once, and stir vigorously until a smooth dough ball forms.|2. Remove from the heat, let cool slightly, and beat the eggs in one by one until the dough turns glossy, thick, and holds its shape.|3. Load the warm dough into a heavy-duty pastry bag fitted with a large open-star nozzle.|4. Pipe long, uniform dough sticks directly into a deep pan of hot frying oil (180°C), cutting the dough cleanly with scissors.|5. Fry the churros for 4 to 5 minutes, turning occasionally, until the star ridges turn exceptionally crispy and dark golden brown.|6. Lift from the oil, drain briefly, and roll the hot churros immediately through a shallow tray packed with cinnamon sugar.|7. Use a long wooden skewer to pierce a hollow tunnel through the center of each churro, and use a thin piping tip to fill it with thick cajeta.
3496	863	1	Knead the flour, yeast, milk, sugar, eggs, orange zest, and orange blossom water together for 15 minutes to develop an elastic dough.|2. Incorporate the softened butter gradually, continuing to knead until the dough turns smooth and shiny; let rise for 2 hours until doubled.|3. Pinch off a quarter of the dough to create the decorations, and shape the remaining dough into a smooth, round dome.|4. Roll the small dough portions into long ropes with bumps to mimic human bones, and shape a tiny ball to represent a teardrop or skull.|5. Arrange the "bone" ropes in a cross pattern directly over the dough dome, and place the small ball securely in the absolute center.|6. Let the decorated loaf rise for another 45 minutes, then bake in a preheated oven at 180°C for 25 minutes until deep golden brown.|7. Brush the hot baked bread heavily with melted butter and sprinkle a dense layer of granulated sugar over the surface immediately.
3497	864	1	Place the fresh sweet corn kernels and the entire can of sweetened condensed milk into a high-powered blender.|2. Pulse the mixture carefully; it should remain slightly textured with tiny bits of corn grit rather than a smooth liquid baby food.|3. Pour the blended corn paste into a massive mixing bowl along with the melted butter, eggs, and vanilla extract; whisk thoroughly.|4. Fold in the flour, baking powder, and a pinch of salt until just combined into a heavy, wet cake batter.|5. Grease a round cake tin heavily with butter and dust lightly with flour to prevent sticking.|6. Pour the wet corn batter into the tin and bake in a preheated oven at 180°C for 45 to 50 minutes.|7. Remove when the top surface is dark golden and a toothpick inserted in the center comes out clean; serve warm or at room temperature.
3498	865	1	Bring the water and a large broken cinnamon stick to a boil in a deep saucepan over medium heat.|2. Add the rinsed white rice, lower the heat, and simmer uncovered for 10 minutes until the rice absorbs the water and softens.|3. Pour in the whole milk and evaporated milk, dropping in a small strip of fresh lime peel if desired.|4. Cook on low heat for 15 minutes, stirring frequently with a wooden spoon to prevent the milk from scorching on the bottom.|5. Stir in the sweetened condensed milk and raisins, turning the heat down to a bare whisper.|6. Simmer for another 10 to 15 minutes, stirring continuously until the rice pudding transforms into a thick, creamy consistency.|7. Remove the cinnamon stick and citrus peel, ladle into small bowls, and dust heavily with ground cinnamon before serving warm or chilled.
3499	866	1	Whisk the flour, egg, milk, sugar, vanilla extract, and salt together in a shallow bowl until a smooth, thin pancake-like batter forms.|2. Heat a deep pan of vegetable oil to 180°C, submerging the metal rosette iron mold directly into the hot oil to heat it thoroughly.|3. Lift the hot iron from the oil, shake off excess droplets, and dip it carefully into the batter only three-quarters of the way up (do not let the batter cover the top of the iron).|4. Plunge the batter-coated iron instantly back into the hot oil; the batter will begin to puff and bubble rapidly.|5. Jiggle the iron gently up and down after 10 seconds; the crisp pastry shell will slide off the mold directly into the oil.|6. Fry for 1 to 2 minutes on each side until the buñuelo turns thin, rigid, and beautifully golden brown.|7. Lift with a slotted spoon, drain quickly on paper towels, and toss immediately through a dish of cinnamon sugar while hot.
3500	867	1	Pour the sweetened condensed milk and evaporated milk together into a blender jar.|2. With the blender running on low speed, pour the fresh lime juice into the milk mixture in a slow, steady stream.|3. Watch as the mixture instantly thickens into a heavy, smooth, and glossy tart cream due to the chemical reaction between the acid and milk.|4. Select a square glass baking dish to assemble the no-bake dessert layers.|5. Arrange a single, tight layer of Galletas Marías flat across the bottom of the glass dish, breaking cookies to fill any gaps.|6. Spread a generous, smooth layer of the lime cream mixture completely over the biscuit base using a spatula.|7. Repeat the cookie and cream layering process 4 or 5 times until the dish is filled, top with lime zest, and freeze for 4 hours until firm.
3501	868	1	Place the piloncillo sugar cones, water, cinnamon stick, whole cloves, and star anise into a deep, heavy saucepan.|2. Heat over medium-high heat, stirring occasionally until the piloncillo breaks down completely and melts into a dark brown liquid.|3. Arrange the thick sweet potato chunks directly into the boiling sugar syrup in a single layer if possible.|4. Turn the heat down to low, cover the saucepan tightly with a lid, and let it simmer gently for 40 minutes.|5. Remove the lid and check the sweet potatoes; they should be translucent, tender, and deeply stained with the dark sugar color.|6. Continue simmering uncovered for another 15 minutes to allow the remaining watery syrup to reduce into a thick, sticky molasses-like glaze.|7. Spoon the hot sweet potatoes into bowls, ladle the rich piloncillo syrup heavily over the top, and serve warm with a drizzle of milk.
3502	869	1	Combine the shredded coconut, condensed milk, egg yolks, vanilla extract, and melted butter thoroughly in a large mixing bowl.|2. Stir the heavy mixture with a wooden spoon until the shredded coconut is entirely saturated with the sweet liquid milk.|3. Let the mixture sit undisturbed for 10 minutes to allow the dry coconut strands to absorb the moisture.|4. Line a large baking sheet with baking paper or silicon mats.|5. Use an ice cream scoop or your hands to shape the sticky coconut mixture into rustic mounds or discs, placing them onto the sheet.|6. Bake in a preheated oven at 175°C for 15 to 18 minutes.|7. Watch closely; the tips and edges of the shredded coconut should turn a deep caramelized golden brown while the interior remains soft and chewy.
3503	870	1	Combine the raw white rice, almonds, and a broken cinnamon stick in a large bowl, cover with boiling water, and let soak overnight.|2. Transfer the completely softened rice, almonds, cinnamon, and the soaking water directly into a high-powered blender jar.|3. Blend on high speed for several minutes until the mixture transforms into an incredibly fine, chalky white paste.|4. Pour the blended mixture through a very fine mesh sieve or a double layer of cheesecloth into a large pitcher to strain out any grain grit.|5. Stir in the evaporated milk and sweetened condensed milk, mixing vigorously until the sugar is fully integrated.|6. Dilute the rich white concentrate with fresh cold water to your desired consistency, adjusting the sweetness with extra sugar if needed.|7. Serve ice-cold in tall glasses packed with ice cubes, topped with a quick dusting of ground cinnamon.
3504	871	1	Rub a spent lime wedge along the entire outer rim of a traditional Margarita glass or a short rocks glass.|2. Roll the wet rim through a saucer packed with coarse sea salt until evenly coated, then fill the glass with ice cubes.|3. Fill a metal cocktail shaker completely to the top with large, solid ice cubes.|4. Pour the tequila shot, fresh lime juice, orange liqueur, and a tiny dash of agave nectar directly over the ice inside the shaker.|5. Close the shaker tightly and shake vigorously for 15 seconds until the exterior of the metal tin turns frosted and freezing cold.|6. Strain the cocktail carefully through a cocktail strainer directly into the salt-rimmed glass over the fresh ice.|7. Garnish the glass with a clean lime wheel and serve immediately.
3505	872	1	Bring water and a cinnamon stick to a boil in a deep saucepan, letting it simmer for 5 minutes to create an aromatic spice tea base.|2. Whisk the Masa Harina corn flour into a separate bowl of warm milk or water until it forms a completely smooth, lump-free liquid slurry.|3. Pour the smooth corn slurry slowly directly into the boiling spice tea pot, whisking continuously to prevent clumps from forming.|4. Drop the chopped Mexican chocolate disk and the piloncillo sugar cone fragments straight into the pot.|5. Turn the heat down to medium-low and cook the beverage for 15 to 20 minutes, whisking continuously with a wooden spoon or a traditional wooden whisk (molinillo).|6. Watch as the beverage transforms, thickening up into a rich, velvety chocolate porridge texture due to the cooking corn flour.|7. Remove the cinnamon stick, pour the hot, steaming beverage into clay mugs, and serve warm on cold mornings or alongside tamales.
3506	873	1	Bring 4 cups of fresh water to a rolling boil in a large saucepan over high heat.|2. Remove from the heat source and dump the dried hibiscus flowers directly into the boiling water.|3. Let the flowers steep undisturbed for 20 to 30 minutes; the water will turn an intensely deep, dark ruby-red color.|4. Strain the liquid through a fine-mesh sieve into a large glass pitcher, discarding the spent, rehydrated hibiscus petals.|5. Pour the white granulated sugar directly into the warm hibiscus concentrate immediately, stirring vigorously until completely dissolved.|6. Add 4 to 5 cups of fresh cold water to dilute the tart concentrate, balancing the intense cranberry-like acidity with the sugar sweetness.|7. Place the pitcher into the refrigerator to chill thoroughly, and serve ice-cold over plenty of ice cubes.
3507	874	1	Run a fresh lime wedge along the outer border of a tall, chilled beer glass or beer mug.|2. Invert the glass rim into a saucer packed with Tajín chili-lime seasoning until uniformly coated.|3. Fill the decorated glass halfway up with large ice cubes.|4. Squeeze the juice of a whole fresh lime directly over the ice cubes inside the glass.|5. Add 2 dashes of Worcestershire sauce, 2 dashes of soy sauce, and 3 heavy drops of Mexican hot sauce depending on your desired spice level.|6. Stir the savory spice sauces gently at the bottom of the glass using a long bar spoon.|7. Open the ice-cold Mexican lager and pour it slowly into the glass, letting the carbonation mix the layers naturally, and serve immediately.
3508	875	1	Place the desalted dried beef, pork trimmings, and soaked black beans into a massive pot, cover with water, and simmer for 1 hour.|2. Add the smoked pork ribs, sliced paio, and calabresa sausages to the pot, continuing to cook on low heat for another hour until the meats are exceptionally tender.|3. Fry the chopped bacon in a separate skillet until crispy, then sauté the minced onions and garlic in the rendered fat until golden brown.|4. Ladle two scoops of the softened black beans from the main pot into the skillet, mashing them with a fork to form a thick paste.|5. Pour the savory bean paste back into the main pot to act as a natural thickener for the stew.|6. Drop in the bay leaves and let the entire mixture simmer uncovered for 20 minutes until the gravy is thick, glossy, and dark.|7. Serve piping hot alongside white rice, garlicky collard greens (couve), orange slices, and toasted cassava flour (farofa).
3509	876	1	Marinate the fish chunks and shrimp in fresh lime juice, minced garlic, salt, and pepper for 30 minutes in the refrigerator.|2. Coat the bottom of a traditional deep clay pot (panela de barro) with a generous drizzle of red palm oil.|3. Arrange half of the sliced onion, tomato, and bell pepper rings flat across the bottom of the pot to form a vegetable bed.|4. Layer the marinated fish pieces and shrimp directly over the vegetables, then top with the remaining vegetable rings.|5. Pour the pure coconut milk and an extra splash of red palm oil evenly over the layers, scattering chopped cilantro across the top.|6. Cover the clay pot tightly and cook over medium heat for 15 to 20 minutes without stirring to prevent the delicate fish from breaking.|7. Remove from the heat when the fish flakes easily and serve directly from the bubbling pot with rice and a savory cassava paste (pirão).
3510	877	1	Use a sharp knife to score the thick white fat cap of the picanha in a diamond crosshatch pattern, taking care not to cut into the red meat.|2. Slice the roast into thick, 2-inch wide steaks against the grain if grilling, or keep it whole if roasting in the oven.|3. Rub the entire surface of the meat heavily and aggressively with coarse sea salt, pressing the crystals firmly into the fat.|4. If grilling, bend the thick slices into a crescent shape with the fat facing outward and thread them onto massive metal skewers.|5. Place the skewers over high-heat charcoal embers, searing the fat side first for 4 minutes until it renders and flares up beautifully.|6. Flip the meat and cook the lean side over medium-low heat for another 8 to 10 minutes until a beautiful crust forms.|7. Tap the skewers firmly with the back of a knife to shake off any excess loose salt crystals before slicing thin and serving medium-rare.
3511	878	1	Sauté minced onions and garlic in a pan, add the shredded chicken, tomato paste, and cream cheese, stirring until smooth; let cool completely.|2. Bring chicken broth and a knob of butter to a rolling boil in a deep saucepan, dump the flour and mashed potatoes in all at once, and stir vigorously.|3. Cook the dough over low heat for 3 minutes until it clears the sides of the pan and forms a smooth, heavy ball; let cool until warm.|4. Knead the dough briefly, pinch off a golf-ball-sized portion, and flatten it into a thin disc in the palm of your hand.|5. Spoon a generous amount of the creamy chicken filling directly into the center of the dough disc.|6. Gather the edges of the dough upward, sealing it tightly at the top and pinching it into a sharp point to mimic a chicken drumstick shape.|7. Dip the shaped teardrops into beaten eggs, roll through fine breadcrumbs uniformly, and deep fry in hot oil until deeply golden and crispy.
3512	879	1	Layer the diced bacon across the bottom of a deep clay pot, followed by the beef chunks, minced onions, garlic, cumin, and bay leaves.|2. Pour in enough water to just cover the meat, layering more onions on top; do not mix or stir the ingredients.|3. Mix the cassava flour with warm water in a small bowl to create a thick, sticky, and clay-like mud paste.|4. Place the heavy lid on the clay pot and use the thick cassava paste to completely smear and seal the gap between the lid and the pot rim.|5. Ensure the seal is completely airtight to prevent any steam or moisture from escaping during the long cooking process.|6. Cook over ultra-low heat (or in a slow oven) for 18 to 20 hours, letting the beef break down into strings in its own pressurized steam.|7. Break the hard clay seal carefully at the table, stir the shredded beef into hot cassava flour until a thick porridge forms, and serve with bananas.
3513	880	1	Boil the peeled cassava chunks in a large pot of salted water until completely soft and fork-tender; drain well.|2. Transfer the hot cassava chunks into a blender along with the coconut milk, blending on high speed until a thick, velvety smooth purée forms.|3. Sauté the diced onions, garlic, bell peppers, and grated tomatoes in a heavy pot with a tablespoon of red palm oil until soft.|4. Toss the marinated shrimp into the skillet, searing them quickly for 2 minutes on each side until they turn bright pink.|5. Pour the smooth, thick cassava-coconut purée directly into the pot with the sautéed vegetables and shrimp.|6. Stir in an extra drizzle of red palm oil, turning the heat down to a low simmer for 5 minutes to let the flavors marry.|7. Scatter fresh chopped cilantro across the top, remove from the heat instantly, and serve warm with white rice.
3514	881	1	Fry the diced bacon or sun-dried beef in a large, heavy saucepan with clarified butter until crispy and browned.|2. Sauté the diced onions and minced garlic in the rendered meat fat until transparent and fragrant.|3. Pour the raw long-grain white rice into the pan, stirring for 1 minute to toast the grains thoroughly in the savory fat.|4. Add the cooked black-eyed peas along with a cup of their reserved cooking liquid and a cup of water or broth.|5. Bring the liquid to a rolling boil, cover the pan tightly with a lid, and lower the heat to a gentle simmer.|6. Cook undisturbed for 15 to 18 minutes until the rice is perfectly fluffy and has absorbed all the liquid.|7. Turn off the heat, stir in the cubes of firm queijo coalho and chopped cilantro, cover for 5 minutes to let the cheese soften, and serve.
3515	882	1	Season the chicken pieces heavily with lime juice, garlic, salt, and pepper, letting them sit for 20 minutes.|2. Heat pequi oil or vegetable oil with turmeric in a deep Dutch oven, searing the chicken pieces until the skin is dark golden and crispy.|3. Push the chicken pieces to the edges of the pan and sauté the chopped onions, garlic, and bell peppers in the center until soft.|4. Stir in the raw long-grain rice, corn kernels, and diced tomatoes, mixing everything together to coat the rice in the golden oil.|5. Pour in hot chicken broth until the rice is completely submerged, bringing the entire pot to a steady boil.|6. Lower the heat to low, cover the pot tightly, and let it simmer for 20 minutes until the rice is tender and the chicken is cooked through.|7. Fluff the golden rice with a fork, scatter a generous handful of chopped parsley and green onions across the top, and serve family-style.
3516	883	1	Rub the cold cubed butter into the flour using your fingers until sandy, add egg yolks and cold water, and press into a smooth pastry dough; chill.|2. Sauté the onions and garlic, add the shredded chicken, corn, sliced olives, tomato sauce, and cream cheese, simmering until thick; cool completely.|3. Divide the chilled pastry dough into two portions, rolling out the larger portion to line the bottom and tall sides of a pie dish.|4. Spoon the completely cooled, creamy chicken filling into the pastry shell, smoothing the surface flat with a spatula.|5. Roll out the remaining dough portion to create a pastry lid, laying it over the filling and crimping the edges tightly to seal.|6. Brush the top pastry lid evenly with a beaten egg yolk to ensure a glossy, golden-brown finish during baking.|7. Bake in a preheated oven at 180°C for 40 to 45 minutes until the pastry is brittle, flaky, and beautifully golden.
3517	884	1	Place the soaked bread rolls, roasted peanuts, cashews, and ground dried shrimp into a blender jar.|2. Pour in the coconut milk and blend on high speed for several minutes until an absolutely smooth, thick nut paste forms.|3. Sauté the minced onions, garlic, and ginger in a large pot with a generous splash of red palm oil until fragrant.|4. Pour the blended nut and bread paste directly into the pot, stirring instantly with a wooden spoon to prevent lumps.|5. Cook over low heat, stirring continuously in a circular motion; the mixture will begin to thicken up significantly.|6. Drizzle in extra red palm oil slowly as it cooks, watching for the paste to release cleanly from the bottom and sides of the pot.|7. Once the mixture turns a deep orange-yellow color and has a glossy sheen, stir in the fresh shrimp until cooked, and serve warm with acarajé.
3518	885	1	Combine the sweetened condensed milk, cocoa powder, and unsalted butter thoroughly in a heavy-bottomed saucepan.|2. Cook the mixture over medium-low heat, stirring continuously with a silicone spatula to prevent the bottom from burning.|3. Continue cooking and stirring for 10 to 12 minutes until the liquid thickens into a heavy, slow-moving paste.|4. Test the readiness by tilting the pan; the chocolate mixture should slide off the bottom cleanly in a single sheet (ponto de brigadeiro).|5. Pour the hot chocolate paste onto a greased plate, spreading it thin, and let cool completely before refrigerating for 1 hour.|6. Grease your hands thoroughly with butter, scoop small portions of the cold paste, and roll them into perfect, smooth spheres.|7. Drop the spheres directly into a bowl of chocolate sprinkles, rolling them around until completely coated, and place in tiny paper cups.
3519	886	1	Brush individual aluminum ramekins heavily with softened butter and dust the insides generously with sugar to create a glossy finish.|2. Mix the granulated white sugar and melted butter together in a bowl until smooth and sandy.|3. Stir the grated coconut into the sugar paste, letting it sit undisturbed for 15 minutes to allow the coconut to release its oils.|4. Pass the egg yolks through a fine mesh sieve directly into the coconut mixture, stirring very gently without creating any air bubbles.|5. Pour the bright yellow liquid custard into the prepared ramekins, filling them three-quarters of the way up.|6. Place the ramekins inside a deep baking tray filled with boiling water (baño maría) to ensure even baking.|7. Bake at 180°C for 45 minutes until the tops are golden brown and firm; cool completely before chilling and flipping onto a plate.
3520	887	1	Melt the sugar and water in a heavy saucepan over medium heat until it liquefies into a clear, golden-amber liquid caramel.|2. Pour the hot caramel quickly into a traditional round tube pan with a center cone, tilting to coat the bottom and inner tube; let cool.|3. Combine the condensed milk, whole milk, and eggs in a blender jar.|4. Blend on low speed for 1 minute just until smooth, then let the liquid sit for 10 minutes to allow any foam bubbles to settle completely.|5. Strain the liquid mixture through a fine sieve directly into the caramelized tube pan over the hard sugar layer.|6. Cover the pan tightly with aluminum foil and place inside a large roasting pan filled with boiling water.|7. Bake at 160°C for 1.5 hours until set, chill in the refrigerator for 4 hours, then run a knife along the edges and flip onto a rimmed platter.
3521	888	1	Mix the sweetened condensed milk, butter, and half of the grated coconut together in a heavy saucepan.|2. Cook over low heat, stirring continuously with a wooden spoon to prevent the milk from sticking to the pan bottom.|3. Cook for 10 minutes until the mixture thickens into a heavy dough that separates cleanly from the pan when tilted.|4. Transfer the sticky white paste onto a buttered plate and let it cool down completely to room temperature.|5. Grease your palms with a thin layer of butter, pinch off small portions of the paste, and roll them into smooth balls.|6. Roll the spheres through a shallow dish packed with granulated sugar or extra grated coconut until coated uniformly.|7. Press a single whole dried clove directly into the absolute center of each ball, adding an aromatic note and a classic look.
3522	889	1	Slice the dense block of sweet goiabada paste into uniform, 1/2-inch thick rectangular slices using a sharp knife.|2. Slice the firm, slightly salty queijo minas cheese into matching 1/2-inch thick rectangular slices.|3. Place a slice of the white cheese directly onto a small dessert plate.|4. Layer a matching slice of the red guava paste directly over the top of the cheese slice.|5. Ensure the proportions are equal to achieve the perfect balance between the salty creaminess and fruit sweetness.|6. Alternatively, cut both the cheese and guava paste into small cubes and skewer them together with toothpicks for parties.|7. Serve at room temperature as a quick, elegant end to a traditional meal.
3523	890	1	Cream the butter and sugar until fluffy, beat in the egg yolks, fold in the flour, and fold in stiffly beaten egg whites to make a thin batter.|2. Spread a paper-thin layer of the batter across a large baking sheet lined with greased parchment paper using an offset spatula.|3. Bake in a preheated oven at 180°C for exactly 3 to 4 minutes (do not let it turn golden or it will become too brittle to roll).|4. Invert the hot cake sheet immediately onto a damp kitchen towel dusted with sugar, peeling away the parchment paper carefully.|5. Spread a thin, warm layer of the melted liquid guava paste completely across the surface of the hot cake sheet.|6. Roll the cake up tightly from the short edge using the towel to guide it, creating a thin, compact cylinder core.|7. Repeat the process with a second thin cake layer, wrapping the new sheet directly around the first cylinder to build layers; dust with powdered sugar.
3524	891	1	Place the roasted peanuts, sugar, flour, and sea salt directly into the bowl of a food processor or a high-powered blender.|2. Pulse the mixture in short bursts; the peanuts will break down, releasing their natural oils and clumping together with the sugar.|3. Avoid over-processing, or the friction will turn the dry powder into a smooth peanut butter paste.|4. Check the texture by squeezing a handful of the powder; it should hold its shape firmly under pressure like wet sand.|5. Select a small cylindrical mold or an empty bottle cap lined with plastic wrap to shape the sweets.|6. Pack the peanut powder tightly and firmly into the mold, compressing it heavily to ensure it binds together properly.|7. Push the dense peanut cylinders out of the mold with care, as they are fragile, and serve dry at room temperature.
3525	892	1	Pour the condensed milk, heavy whipping cream, and concentrated passion fruit juice together into a blender jar.|2. Blend on high speed for 2 minutes; the high acid content in the passion fruit juice will thicken the cream instantly into a mousse.|3. Pour the smooth, pale yellow cream mixture into individual glass cups or a wide glass serving bowl.|4. Transfer the mousse into the refrigerator to chill and set firm for at least 3 hours.|5. To make the decorative top glaze, simmer the fresh passion fruit pulp, seeds, sugar, and cornstarch in a pan until thick and glossy; cool.|6. Spoon the cooled, seedy passion fruit glaze evenly over the top surface of the chilled cream layer.|7. Return to the refrigerator for another hour and serve ice-cold as a refreshing tropical treat.
3526	893	1	Boil the sugar, water, cinnamon stick, and whole cloves in a saucepan until a light, clear simple syrup forms.|2. Stir the thick strands of fresh grated coconut directly into the boiling syrup, cooking for 5 minutes until translucent.|3. Pour in the whole milk and sweetened condensed milk, turning the heat down to a low simmer.|4. Cook the mixture for 15 minutes, stirring frequently with a wooden spoon to prevent the milk from scorching on the bottom.|5. Whisk a scoop of the hot coconut liquid into the beaten egg yolks to temper them, then pour the yolk mixture back into the pot.|6. Simmer on ultra-low heat for an additional 5 minutes, stirring vigorously until the pudding turns thick, creamy, and golden-yellow.|7. Remove the cinnamon stick and cloves, pour into small glass jars, and serve warm or at room temperature.
3527	894	1	Place the fresh sweet corn kernels and whole milk into a high-powered blender, blending on high speed until completely liquid.|2. Pour the milky corn liquid through a very fine mesh sieve or cheesecloth into a deep pot, squeezing hard to extract all the starch while discarding the solid husks.|3. Stir the granulated white sugar, butter, and a tiny pinch of salt directly into the strained corn milk.|4. Place the pot over medium heat and bring to a simmer, stirring continuously with a wooden spoon without stopping.|5. Watch closely as the mixture heats up; the natural corn starches will cook and thicken the liquid rapidly into a heavy custard texture.|6. Lower the heat and cook for another 10 minutes, stirring constantly to ensure a perfectly smooth, lump-free pudding.|7. Pour the hot pudding into individual bowls, let cool to room temperature until a skin forms, and dust heavily with ground cinnamon before chilling.
3528	895	1	Cut the fresh lime in half, slice out the bitter white central pith string, and chop the lime into 8 small wedges.|2. Place the lime wedges skin-side down into the bottom of a short, heavy rocks glass.|3. Sprinkle the sugar directly over the lime wedges inside the glass.|4. Use a wooden muddler to press down firmly on the limes, extracting the fresh juice and blending it with the abrasive sugar crystals to release the skin oils.|5. Fill the glass completely to the top rim with crushed ice or small ice cubes.|6. Pour a generous shot of pure cachaça spirit directly over the ice dome.|7. Stir the drink quickly from the bottom up using a short spoon or pour it back and forth once into a shaker tin, and serve immediately.
3529	896	1	Dissolve the guaraná extract powder thoroughly into a small splash of hot water with simple syrup to create a sweet, dark brown concentrate.|2. Let the herbal berry concentrate cool completely down to room temperature before assembling.|3. Select a tall, chilled highball glass and pack it to the brim with large, solid ice cubes.|4. Pour the cooled guaraná berry concentrate directly over the ice in the bottom of the glass.|5. Top up the remaining space slowly with ice-cold carbonated water or club soda.|6. Stir gently using a long bar spoon from the bottom up to preserve the carbonation while blending the layers.|7. Garnish the glass rim with a fresh slice of lemon or lime and serve ice-cold as a crisp refresher.
3530	897	1	Clean the raw sugar cane stalks thoroughly, stripping away the tough green outer bark to expose the fibrous core.|2. Feed the split sugar cane stalks steadily through a traditional heavy motorized roller press (moenda).|3. Place a large pitcher beneath the press spout to catch the stream of opaque, pale green raw juice as it is squeezed out.|4. Feed a fresh lime half or a slice of ginger through the rollers along with the sugar cane to balance the intense sweetness with acidity.|5. Pass the extracted raw sugar cane juice through a fine wire mesh strainer to eliminate any loose wood fibers or grit.|6. Fill tall glasses completely to the top with large ice cubes.|7. Pour the fresh, foaming green juice over the ice and serve instantly before the raw liquid oxidizes and changes color.
3531	898	1	Pour fresh water directly into a small saucepan or a traditional coffee pot over medium-high heat.|2. Add a generous amount of granulated white sugar straight into the cold water, stirring until dissolved, and bring to a boil.|3. Just as the sweet water hits a rolling boil, turn off the heat source immediately.|4. Dump the finely ground dark roast coffee beans directly into the hot sugar water, stirring vigorously with a wooden spoon.|5. Let the mixture sit undisturbed for 1 minute to allow the coffee grounds to steep and infuse deeply.|6. Pour the hot mixture through a traditional cloth cone filter (coador) held over a small ceramic pitcher or thermos.|7. Serve the steaming, sweet black coffee immediately in tiny, demitasse-sized ceramic cups.
3532	899	1	Place the fresh chopped pineapple chunks and a large handful of washed fresh mint leaves directly into a blender jar.|2. Pour in a cup of fresh cold water to help the blades catch and blend effectively.|3. Add a small spoonful of sugar or honey if the pineapple is slightly tart or out of season.|4. Blend on high speed for 2 full minutes until the pineapple fibers are completely broken down and liquid.|5. Watch as the mixture builds a massive, thick layer of beautiful pale green froth at the surface of the blender jar.|6. Strain the liquid through a mesh sieve into a large pitcher if you prefer a smooth drink, or keep it unstrained for a thick texture.|7. Pour immediately into tall glasses filled with extra ice cubes and garnish with a fresh mint sprig.
\.


--
-- Data for Name: users; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY public.users (id, username, phone_number, password, created_at) FROM stdin;
1	elen	09669911012	868cf9f0246aeff736d76108c52d517e9537024286f196d0e05e58e127466a99	2026-05-29 02:46:02.866434
\.


--
-- Data for Name: voice_command; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY public.voice_command (id, user_id, command, action, recipe_id, created_at) FROM stdin;
\.


--
-- Name: ingredients_id_seq; Type: SEQUENCE SET; Schema: public; Owner: postgres
--

SELECT pg_catalog.setval('public.ingredients_id_seq', 4918, true);


--
-- Name: recipe_folders_id_seq; Type: SEQUENCE SET; Schema: public; Owner: postgres
--

SELECT pg_catalog.setval('public.recipe_folders_id_seq', 1, false);


--
-- Name: recipes_id_seq; Type: SEQUENCE SET; Schema: public; Owner: postgres
--

SELECT pg_catalog.setval('public.recipes_id_seq', 899, true);


--
-- Name: shopping_list_id_seq; Type: SEQUENCE SET; Schema: public; Owner: postgres
--

SELECT pg_catalog.setval('public.shopping_list_id_seq', 5, true);


--
-- Name: steps_id_seq; Type: SEQUENCE SET; Schema: public; Owner: postgres
--

SELECT pg_catalog.setval('public.steps_id_seq', 3532, true);


--
-- Name: users_id_seq; Type: SEQUENCE SET; Schema: public; Owner: postgres
--

SELECT pg_catalog.setval('public.users_id_seq', 1, true);


--
-- Name: voice_command_id_seq; Type: SEQUENCE SET; Schema: public; Owner: postgres
--

SELECT pg_catalog.setval('public.voice_command_id_seq', 1, false);


--
-- Name: favorites favorites_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.favorites
    ADD CONSTRAINT favorites_pkey PRIMARY KEY (user_id, recipe_id);


--
-- Name: ingredients ingredients_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.ingredients
    ADD CONSTRAINT ingredients_pkey PRIMARY KEY (id);


--
-- Name: recipe_folders recipe_folders_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.recipe_folders
    ADD CONSTRAINT recipe_folders_pkey PRIMARY KEY (id);


--
-- Name: recipes recipes_dish_id_key; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.recipes
    ADD CONSTRAINT recipes_dish_id_key UNIQUE (dish_id);


--
-- Name: recipes recipes_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.recipes
    ADD CONSTRAINT recipes_pkey PRIMARY KEY (id);


--
-- Name: shopping_list shopping_list_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.shopping_list
    ADD CONSTRAINT shopping_list_pkey PRIMARY KEY (id);


--
-- Name: steps steps_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.steps
    ADD CONSTRAINT steps_pkey PRIMARY KEY (id);


--
-- Name: users users_phone_number_key; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.users
    ADD CONSTRAINT users_phone_number_key UNIQUE (phone_number);


--
-- Name: users users_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.users
    ADD CONSTRAINT users_pkey PRIMARY KEY (id);


--
-- Name: users users_username_key; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.users
    ADD CONSTRAINT users_username_key UNIQUE (username);


--
-- Name: voice_command voice_command_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.voice_command
    ADD CONSTRAINT voice_command_pkey PRIMARY KEY (id);


--
-- Name: favorites favorites_recipe_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.favorites
    ADD CONSTRAINT favorites_recipe_id_fkey FOREIGN KEY (recipe_id) REFERENCES public.recipes(id) ON DELETE CASCADE;


--
-- Name: favorites favorites_user_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.favorites
    ADD CONSTRAINT favorites_user_id_fkey FOREIGN KEY (user_id) REFERENCES public.users(id) ON DELETE CASCADE;


--
-- Name: ingredients ingredients_recipe_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.ingredients
    ADD CONSTRAINT ingredients_recipe_id_fkey FOREIGN KEY (recipe_id) REFERENCES public.recipes(id) ON DELETE CASCADE;


--
-- Name: recipe_folders recipe_folders_user_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.recipe_folders
    ADD CONSTRAINT recipe_folders_user_id_fkey FOREIGN KEY (user_id) REFERENCES public.users(id) ON DELETE CASCADE;


--
-- Name: recipes recipes_user_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.recipes
    ADD CONSTRAINT recipes_user_id_fkey FOREIGN KEY (user_id) REFERENCES public.users(id);


--
-- Name: shopping_list shopping_list_user_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.shopping_list
    ADD CONSTRAINT shopping_list_user_id_fkey FOREIGN KEY (user_id) REFERENCES public.users(id) ON DELETE CASCADE;


--
-- Name: steps steps_recipe_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.steps
    ADD CONSTRAINT steps_recipe_id_fkey FOREIGN KEY (recipe_id) REFERENCES public.recipes(id) ON DELETE CASCADE;


--
-- Name: voice_command voice_command_recipe_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.voice_command
    ADD CONSTRAINT voice_command_recipe_id_fkey FOREIGN KEY (recipe_id) REFERENCES public.recipes(id);


--
-- Name: voice_command voice_command_user_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.voice_command
    ADD CONSTRAINT voice_command_user_id_fkey FOREIGN KEY (user_id) REFERENCES public.users(id) ON DELETE CASCADE;


--
-- PostgreSQL database dump complete
--

\unrestrict CDEM5NrPrr4ZY9xQNaOn3KGDKagF4TPu0WJDWPK0oeKpnPGAxfgzn7Y6S0iqdYj

