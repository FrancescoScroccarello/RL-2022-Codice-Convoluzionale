library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.NUMERIC_STD.ALL;

entity project_reti_logiche is
  Port (
    i_clk : in std_logic;
    i_rst : in std_logic;
    i_start : in std_logic;
    i_data : in std_logic_vector(7 downto 0);
    o_address : out std_logic_vector(15 downto 0);
    o_done : out std_logic;
    o_en : out std_logic;
    o_we : out std_logic;
    o_data : out std_logic_vector (7 downto 0)
  );
end project_reti_logiche;

architecture Behavioral of project_reti_logiche is
type state_t is(
    RESET,
    START,
    READ,
    WRITE,
    OPERATIONS,
    UPDATE_STATES,
    CHECK,
    DONE
);
signal state : state_t:=RESET; 
signal next_state : state_t:=RESET;
signal input : std_logic_vector(7 downto 0):=(others=>'0');
signal output : std_logic_vector(7 downto 0):=(others=>'0');
signal x : std_logic:='0';
signal q1 : std_logic:='0';
signal q2 : std_logic:='0';
signal times : std_logic_vector(7 downto 0):=(others=>'0');
signal count_input : std_logic_vector(15 downto 0):=(others=>'0');
signal count_output : std_logic_vector(15 downto 0):=(others=>'0');
signal position : integer:=8;
begin

 SYNC_PROC: process (i_clk)
  begin
     if rising_edge(i_clk) then
        if i_rst = '1' then
           state <= RESET;
        else  
           state <= next_state;
        end if;
     end if;    
     
  end process;
  
 NEXT_STATE_DECODE: process (i_clk)
       begin
        if falling_edge(i_clk) then
            case state is
             when RESET =>
                    x<='0';
                    q1<='0';
                    q2<='0';
                    output<=(others=>'0');
                    input<=(others=>'0');
                    count_input<=(others=>'0');
                    count_output<=(others=>'0');
                    o_address<=(others=>'0');
                    position<=8;
                    o_en<='1';
                    o_we<='0';
                    o_done<='0';
                    next_state<=START;
                
             when START =>
                if i_start='1' then
                     times<=i_data;
                     next_state<=CHECK;
                else
                    next_state<=START;
                end if;               
                
              when READ =>
                input<=i_data; 
                next_state<=UPDATE_STATES;

             when UPDATE_STATES=>
                 output<=output(5 downto 0) & "00";
                 q2<=q1;
                 q1<=x;
                 x<=input(7);
                 next_state<=OPERATIONS;
   
             when OPERATIONS=>
                output(1)<=x xor q2;
                output(0)<=x xor (q1 xor q2);
                position<=position+1;
                input<=input(6 downto 0)&'0';
                if position=3 then
                    next_state<=WRITE;
                elsif position=7 then
                     next_state<=WRITE;
                else
                    next_state<=UPDATE_STATES;
                end if;       
                  
             when WRITE =>
                o_address<=std_logic_vector(unsigned(count_output)+1000);
                count_output<=std_logic_vector(unsigned(count_output)+1);
                o_data<=output;
                o_we<='1';
                next_state<=CHECK;                
                
             when CHECK =>
                o_we<='0';
                if position=8 then 
                    if to_integer(unsigned(count_input))=to_integer(unsigned(times)) then
                        next_state<=DONE;
                    else    
                        o_address<=std_logic_vector(unsigned(count_input)+1);
                        count_input<=std_logic_vector(unsigned(count_input)+1);
                        position<=0;
                        next_state<=READ;
                    end if;
                else                        
                    next_state<=UPDATE_STATES;
                end if;                   
            
              when DONE=>
                o_done<='1';
                o_en<='0';
                next_state<=RESET;
                                            
          end case; 
          end if;
       end process;   
end Behavioral;
