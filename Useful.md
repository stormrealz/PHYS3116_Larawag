# Master Catalogue Data Dictionary 
This Dictionary was made using generative AI to aid in interpretation of data sets in the master_catalogue.

(`master_catalogue.csv`)

The catalogue uses a two-level pandas MultiIndex header:
- **Level 0 (`source`)**: Source dataset (`meta`, `h1`, `h3`, `k`, `vb`).
- **Level 1 (`quantity`)**: Parameter name.

---

### 1. `meta` — Unified Cross-Matching & Identification

| Level 0 (`source`) | Level 1 (`quantity`) | Data Type | Units | Description & Scientific Use |
| :--- | :--- | :--- | :--- | :--- |
| **`meta`** | **`cluster_id`** | String | None | Primary index/key for the master table (e.g. `NGC 104`, `Pal 1`, `Terzan 7`, `UNMATCHED:vb:ARP21`). |
| **`meta`** | **`preferred_name`** | String | None | Most common/familiar name used for plots and tables (e.g. `47 Tuc`, `M 68`, `omega Cen`). |
| **`meta`** | **`NGC`** | Int64 | None | Standardised integer NGC number (nullable integer; `<NA>` for non-NGC clusters like Palomar or Terzan objects). |
| **`meta`** | **`matched_to_harris`** | Boolean | None | `True` if the cluster successfully matched to an entry in the Harris 158-cluster reference catalogue. |

---

### 2. `h1` — Harris Part I (Positions, Coordinates & Distances)
*(Harris 1996, 2010 edition: 158 clusters)*

| Level 0 (`source`) | Level 1 (`quantity`) | Data Type | Units | Description & Scientific Use |
| :--- | :--- | :--- | :--- | :--- |
| **`h1`** | **`ID`** | String | None | Original cluster identifier in Harris Part I (e.g. `NGC 104`). |
| **`h1`** | **`Name`** | String | None | Original alternative name in Harris Part I (e.g. `47 Tuc`). |
| **`h1`** | **`RA`** | String | `hh:mm:ss.s` | Right Ascension in J2000 equatorial coordinates. |
| **`h1`** | **`DEC`** | String | `+dd:mm:ss` | Declination in J2000 equatorial coordinates. |
| **`h1`** | **`L`** | Float | Degrees ($^\circ$) | Galactic Longitude ($l$), direction around the Milky Way disk plane ($0^\circ \le l < 360^\circ$). |
| **`h1`** | **`B`** | Float | Degrees ($^\circ$) | Galactic Latitude ($b$), angle above/below the Galactic disk ($-90^\circ \le b \le +90^\circ$). |
| **`h1`** | **`R_Sun`** | Float | $\text{kpc}$ | Heliocentric distance: physical distance from the Sun to the cluster ($1\text{ kpc} = 1000\text{ pc}$). |
| **`h1`** | **`R_gc`** | Float | $\text{kpc}$ | Galactocentric distance: 3D physical distance from the Galactic Centre (assumes $R_0 = 8.0\text{ kpc}$). Primary parameter to identify outer halo / accreted clusters ($R_{\text{gc}} > 10 - 15\text{ kpc}$). |
| **`h1`** | **`X`** | Float | $\text{kpc}$ | Heliocentric Cartesian Galactic coordinate pointing from Sun towards the Galactic Centre ($l=0^\circ, b=0^\circ$). |
| **`h1`** | **`Y`** | Float | $\text{kpc}$ | Heliocentric Cartesian Galactic coordinate in the direction of Galactic rotation ($l=90^\circ, b=0^\circ$). |
| **`h1`** | **`Z`** | Float | $\text{kpc}$ | Heliocentric Cartesian Galactic coordinate perpendicular to the Galactic disk pointing toward North Galactic Pole ($b=+90^\circ$). $|Z|$ measures height above/below the disk. |
| **`h1`** | **`NGC`** | Int64 | None | NGC integer extracted from Harris Part I. |

---

### 3. `h3` — Harris Part III (Kinematics, Velocities & Structure)
*(Harris 1996, 2010 edition: 158 clusters)*

| Level 0 (`source`) | Level 1 (`quantity`) | Data Type | Units | Description & Scientific Use |
| :--- | :--- | :--- | :--- | :--- |
| **`h3`** | **`ID`** | String | None | Original cluster identifier in Harris Part III. |
| **`h3`** | **`v_r`** | Float | $\text{km s}^{-1}$ | Heliocentric line-of-sight radial velocity ($+ = \text{receding from Sun}$, $- = \text{approaching Sun}$). |
| **`h3`** | **`v_r_e`** | Float | $\text{km s}^{-1}$ | Observational uncertainty in $v_r$. |
| **`h3`** | **`v_LSR`** | Float | $\text{km s}^{-1}$ | Radial velocity corrected for the Sun's peculiar motion relative to the Local Standard of Rest (LSR). Crucial for studying orbital dipole and Galactic rotation. |
| **`h3`** | **`sig_v`** | Float | $\text{km s}^{-1}$ | Central internal velocity dispersion ($\sigma_v$): internal stellar velocity spread in the cluster core (describes cluster mass, not orbital speed). |
| **`h3`** | **`sig_v_e`** | Float | $\text{km s}^{-1}$ | Observational uncertainty in $\sigma_v$. |
| **`h3`** | **`c`** | Float / String | Dimensionless | King central concentration parameter: $c = \log_{10}(r_t / r_c)$, where $r_t$ is tidal radius and $r_c$ is core radius. High $c$ ($\ge 2.5$) indicates core-collapsed clusters. |
| **`h3`** | **`r_c`** | Float | $\text{arcmin}$ | Core angular radius on the sky ($1'\text{ arcmin} = 1/60^\circ$). **Warning: Not parsecs!** |
| **`h3`** | **`r_h`** | Float | $\text{arcmin}$ | Half-light angular radius on the sky. **Warning: Not parsecs!** |
| **`h3`** | **`mu_V`** | Float | $\text{mag arcsec}^{-2}$ | Central visual surface brightness ($\mu_V(0)$). Lower magnitude means higher surface brightness. |
| **`h3`** | **`rho_0`** | Float | $\log_{10}(L_{\odot, V} \text{ pc}^{-3})$ | Base-10 logarithm of central luminosity density in solar visual luminosities per cubic parsec. |
| **`h3`** | **`lg_tc`** | Float | $\log_{10}(\text{yr})$ | Base-10 logarithm of core relaxation time (dynamical timescale for stars in the core to exchange energy). |
| **`h3`** | **`lg_th`** | Float | $\log_{10}(\text{yr})$ | Base-10 logarithm of median relaxation time at the half-mass radius. |
| **`h3`** | **`NGC`** | Int64 | None | NGC integer extracted from Harris Part III. |

---

### 4. `k` — Krause et al. (2021) (Masses, Compactness & Multiple Populations)
*(61 clusters)*

| Level 0 (`source`) | Level 1 (`quantity`) | Data Type | Units | Description & Scientific Use |
| :--- | :--- | :--- | :--- | :--- |
| **`k`** | **`Class`** | String | None | Object class (`GC` for Globular Cluster). |
| **`k`** | **`Object`** | String | None | Identifier without spaces (e.g. `NGC104`, `Terzan7`, `Palomar12`). |
| **`k`** | **`AltName`** | String | None | Historical Messier / Dunlop / Caldwell name (e.g. `47Tuc`, `M69`, `NONE`). |
| **`k`** | **`Mstar`** | Float | $10^5 \, M_\odot$ | Total stellar mass ($M_*$) of the cluster in units of $10^5$ solar masses (e.g., $6.46 = 6.46 \times 10^5 \, M_\odot$). |
| **`k`** | **`rh`** | Float | $\text{pc}$ | Physical 3D half-mass radius in **parsecs**. *(Note: Unlike Harris `r_h` in arcmin, this is physical size).* |
| **`k`** | **`C5`** | Float | Dimensionless | Compactness index $C_5 \equiv \frac{M_* / 10^5 M_\odot}{r_h / \text{pc}}$. Measures gravitational depth for retaining enriched gas; test if accreted clusters are less compact. |
| **`k`** | **`Age`** | Float | $\text{Gyr}$ | Literature-compiled cluster age. *(Heterogeneous; lacks error bars; systematic offsets at high $[\mathrm{Fe}/\mathrm{H}]$).* |
| **`k`** | **`FeH`** | Float | $\text{dex}$ | Spectroscopic metallicity $[\mathrm{Fe}/\mathrm{H}]$ in dex. |
| **`k`** | **`NGC`** | Int64 | None | NGC integer extracted from Krause. |

---

### 5. `vb` — VandenBerg et al. (2013) (High-Precision Ages & Relative CMDs)
*(55 clusters)*

| Level 0 (`source`) | Level 1 (`quantity`) | Data Type | Units | Description & Scientific Use |
| :--- | :--- | :--- | :--- | :--- |
| **`vb`** | **`NGC`** | Int64 | None | NGC number in VandenBerg table. |
| **`vb`** | **`Name`** | String | None | Alternative name in VandenBerg table (e.g. `47Tuc`, `M68`, `XXXX`). |
| **`vb`** | **`FeH`** | Float | $\text{dex}$ | Metallicity $[\mathrm{Fe}/\mathrm{H}]$ on the homogeneous Carretta et al. (2009) scale. |
| **`vb`** | **`Age`** | Float | $\text{Gyr}$ | Primary adopted cluster age (Gyr) from homogeneous HST ACS photometry. |
| **`vb`** | **`Age_err`** | Float | $\text{Gyr}$ | Formal statistical age uncertainty ($\pm\text{Gyr}$). |
| **`vb`** | **`Method`** | Categorical | None | CMD age method: `V` = Vertical ($\Delta V_{\text{TO}}^{\text{HB}}$), `H` = Horizontal ($\Delta(V-I)$), `A` = Average / Isochrone fit. |
| **`vb`** | **`Figs`** | String | None | Figure number in the 2013 paper showing the cluster's CMD fits. |
| **`vb`** | **`Range`** | String | $\text{Gyr}$ | Age interval of acceptable isochrone overlays (e.g. `11.50–11.75`). |
| **`vb`** | **`HBtype`** | Float | Dimensionless | Lee-Zinn Horizontal Branch index: $\frac{B - R}{B + V + R}$ ($-1.0 = \text{red HB}$, $+1.0 = \text{blue HB}$). Explores the second-parameter problem. |
| **`vb`** | **`R_G`** | Float | $\text{kpc}$ | Galactocentric distance ($R_{\text{GC}}$) in kiloparsecs. |
| **`vb`** | **`M_V`** | Float | $\text{mag}$ | Absolute integrated visual magnitude (optical luminosity proxy). |
| **`vb`** | **`v_e0`** | Float | $\text{km s}^{-1}$ | Central escape velocity from McLaughlin & van der Marel (2005) King models. |
| **`vb`** | **`log_sigma_0`**| Float | $\log_{10}(L_{\odot, V} \text{ pc}^{-2})$ | Central surface brightness / surface mass density parameter $\log_{10} \Sigma_0$. |

---

### Critical Traps & Unit Differences to Watch Out For
1. **Cluster Radii:**
   - `('h3', 'r_h')` and `('h3', 'r_c')` are **angular sizes in arcminutes** on the sky.
   - `('k', 'rh')` is **physical size in parsecs** ($\text{pc}$). Do not mix them up!
2. **Galactic Coordinates vs. Distances:**
   - `X`, `Y`, `Z` are **Sun-centred** Cartesian coordinates ($\text{kpc}$).
   - `R_gc` / `R_G` is the **Galactocentric 3D distance** ($\text{kpc}$) from the Milky Way's core.
3. **Radial Velocities:**
   - `v_r` is heliocentric (relative to the Sun).
   - `v_LSR` corrects for the Sun's orbital motion; a negative `v_LSR` does **not** mean retrograde Galactic rotation (it only means motion toward the Sun). Proper 3D tangential velocities require Gaia proper motions.

   TODO: add guide for filtered data sets

   