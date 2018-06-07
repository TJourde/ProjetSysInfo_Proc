library IEEE;
use IEEE.STD_LOGIC_1164.ALL;

-- Uncomment the following library declaration if using
-- arithmetic functions with Signed or Unsigned values
--use IEEE.NUMERIC_STD.ALL;

-- Uncomment the following library declaration if instantiating
-- any Xilinx primitives in this code.
--library UNISIM;
--use UNISIM.VComponents.all;

entity micro_alu is
--create port RST & clk
PORT( RST : in STD_LOGIC;
      clk : in  STD_LOGIC;
		input : IN  std_logic_vector(31 downto 0);
		data_di: IN  std_logic_vector(15 downto 0);
		data_we: OUT std_logic;
		data_a:OUT  std_logic_vector(15 downto 0);
		data_do:OUT  std_logic_vector(15 downto 0)
		);
end micro_alu;

architecture Behavioral of micro_alu is
 
    -- Component Declaration for the Unit Under Test (UUT)
 
    COMPONENT decoder
    PORT(
         ins_di : IN  std_logic_vector(31 downto 0);
         A : OUT  std_logic_vector(15 downto 0);
         B : OUT  std_logic_vector(15 downto 0);
         OP : OUT  std_logic_vector(7 downto 0);
			C : OUT  std_logic_vector(15 downto 0)
        );
    END COMPONENT;
    
	 COMPONENT registre
	 PORT(
			 RST : in STD_LOGIC;
			 RAadr : in STD_LOGIC_VECTOR(3 downto 0);
			 RBadr : in STD_LOGIC_VECTOR(3 downto 0);
			 QA : out STD_LOGIC_VECTOR(15 downto 0);
			 QB : out STD_LOGIC_VECTOR(15 downto 0);
			 --@W, W et DATA.
			 RWadr : in STD_LOGIC_VECTOR(3 downto 0);
			 W : in STD_LOGIC;
			 DATA : in STD_LOGIC_VECTOR(15 downto 0);
          clk : in  STD_LOGIC
	 );
	 END COMPONENT;
	 
	 COMPONENT lc
	 PORT(
			OP : in  STD_LOGIC_VECTOR (7 downto 0);
         W : out  STD_LOGIC
	 );
	 END COMPONENT;
	 
	 COMPONENT pipeline
    PORT(
         A_in : IN  std_logic_vector(15 downto 0);
         B_in : IN  std_logic_vector(15 downto 0);
         C_in : IN  std_logic_vector(15 downto 0);
         OP_in : IN  std_logic_vector(7 downto 0);
         A_out : OUT  std_logic_vector(15 downto 0);
         B_out : OUT  std_logic_vector(15 downto 0);
         C_out : OUT  std_logic_vector(15 downto 0);
         OP_out : OUT  std_logic_vector(7 downto 0);
         clk : IN  std_logic
        );
    END COMPONENT;
	 
	 COMPONENT alu is
    Port ( A : in  STD_LOGIC_VECTOR (15 downto 0);
           B : in  STD_LOGIC_VECTOR (15 downto 0);
           OP : in  STD_LOGIC_VECTOR (7 downto 0);
           S : out  STD_LOGIC_VECTOR (15 downto 0);
           Flag : out  STD_LOGIC_VECTOR (3 downto 0)); --ZCNV
	end COMPONENT;
	COMPONENT mux is
	Port ( OP : in  STD_LOGIC_VECTOR (7 downto 0);
           B_in : in  STD_LOGIC_VECTOR (15 downto 0);
           newB : in  STD_LOGIC_VECTOR (15 downto 0);
           B_out : out  STD_LOGIC_VECTOR (15 downto 0));
	end COMPONENT;


   --Inputs
   signal ins_di_d : std_logic_vector(31 downto 0) := (others => '0');
	
	--signal RST_r : std_logic;
	signal RAadr_r : std_logic_vector(3 downto 0);
	signal RBadr_r : std_logic_vector(3 downto 0);
	--signal RWadr_r : std_logic_vector(3 downto 0);

	signal DATA_r : std_logic_vector(15 downto 0);
   --signal clk :  std_logic := '0';
	
	signal B_in_di : std_logic_vector(15 downto 0);
	
	

	
 
 	--Outputs
   signal A_d : std_logic_vector(15 downto 0);
   signal B_d : std_logic_vector(15 downto 0);
   signal OP_d : std_logic_vector(7 downto 0);
	signal C_d : std_logic_vector(15 downto 0);
	
	signal QA_r : std_logic_vector(15 downto 0);
	signal QB_r : std_logic_vector(15 downto 0);
	
	signal W_lc : std_logic;
	signal W_lc_data : std_logic;
	
	signal S_alu : STD_LOGIC_VECTOR (15 downto 0);
   signal Flag_alu : STD_LOGIC_VECTOR (3 downto 0); --ZCNV
	
	signal B_out_mux1 : STD_LOGIC_VECTOR (15 downto 0);
	signal B_out_mux2 : STD_LOGIC_VECTOR (15 downto 0);
	signal B_out_mux3 : STD_LOGIC_VECTOR (15 downto 0);
	
   signal A_out_li : std_logic_vector(15 downto 0);
   signal B_out_li : std_logic_vector(15 downto 0);
   signal C_out_li : std_logic_vector(15 downto 0);
   signal OP_out_li : std_logic_vector(7 downto 0);
	
	signal A_out_di : std_logic_vector(15 downto 0);
   signal B_out_di : std_logic_vector(15 downto 0);
   signal C_out_di : std_logic_vector(15 downto 0);
   signal OP_out_di : std_logic_vector(7 downto 0);
	
	signal A_out_ex : std_logic_vector(15 downto 0);
   signal B_out_ex : std_logic_vector(15 downto 0);
   signal C_out_ex : std_logic_vector(15 downto 0);
   signal OP_out_ex : std_logic_vector(7 downto 0);
	
	signal A_out_mem : std_logic_vector(15 downto 0);
   signal B_out_mem : std_logic_vector(15 downto 0);
   signal C_out_mem : std_logic_vector(15 downto 0);
   signal OP_out_mem : std_logic_vector(7 downto 0);
	
	-- Clock period definitions
   constant clk_period : time := 10 ns;
 

 
BEGIN
 
	-- Instantiate the Unit Under Test (UUT)
   uud: decoder PORT MAP (
          ins_di => input,
          A => A_d,
          B => B_d,
          OP => OP_d,
			 C => C_d
        );
    uur: registre PORT MAP (
			RST => RST,
			RAadr => B_out_li(11 downto 8),
			RBadr => C_out_li(11 downto 8),
			W => W_lc,
			DATA => DATA_r,
			QA => QA_r,
			QB => QB_r,
			RWadr => A_out_mem(11 downto 8),
         clk => clk
	 );
	 uulc:lc PORT MAP(
			OP => OP_out_mem,
			W => W_lc
	 );
	 uulc_data:lc PORT MAP(
		   OP => OP_out_di,
	   	W => W_lc_data
	 );
	 uua:alu PORT MAP(
			A => B_out_di,
			B => C_out_di,
			OP => OP_out_di,
			S => S_alu,
			Flag => Flag_alu
	 );
	 uum:mux PORT MAP(
			OP => OP_out_li,
			B_in => B_out_li,
			newB => QA_r,
			B_out => B_out_mux1
	 );

	 
	 uup_li:pipeline PORT MAP(
			A_in => A_d,
			B_in => B_d,
			OP_in => OP_d,
			C_in => C_d,
			A_out => A_out_li,
			B_out => B_out_li,
			OP_out => OP_out_li,
			C_out => C_out_li,
			clk => clk
	 );
	 
	 
	 	 uup_di:pipeline PORT MAP(
			A_in => A_out_li,
			B_in => B_out_mux1,
			OP_in => OP_out_li,
			C_in => QB_r,
			A_out => A_out_di,
			B_out => B_out_di,
			OP_out => OP_out_di,
			C_out => C_out_di,
			clk => clk
	 );
	 
	 	 uup_ex:pipeline PORT MAP(
			A_in => A_out_di,
			B_in => B_in_di,
			OP_in => OP_out_di,
			C_in => C_out_di,
			A_out => A_out_ex,
			B_out => B_out_ex,
			OP_out => OP_out_ex,
			C_out => C_out_ex,
			clk => clk
	 );
	 
	 	 uup_mem:pipeline PORT MAP(
			A_in => A_out_ex,
			B_in => B_out_ex,
			OP_in => OP_out_ex,
			C_in => C_out_ex,
			A_out => A_out_mem,
			B_out => B_out_mem,
			OP_out => OP_out_mem,
			C_out => C_out_mem,
			clk => clk
	 );
	
	 
	 DATA_r <= data_di when OP_out_mem=x"07" else B_out_mem ;
	
	
	B_in_di <= S_alu when OP_out_di=x"01" or OP_out_di=x"02" or OP_out_di=x"03" else B_out_di;
	
	data_a <= A_out_ex when OP_out_ex=x"08" else B_out_ex;
	data_we <= '1' when OP_out_ex=x"08" else '0' ;
	data_do <= B_out_ex;
	
END Behavioral;


